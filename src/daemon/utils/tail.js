var chalk     = require('chalk')
var Events    = require('events')
var fs        = require('fs')
var path      = require('path')
var config    = require('../../config.js')
var Util      = require('util')


function log(msg, err) {
  var str = chalk.blue('[tail]') + ' ' + msg
  str += err ? ' [' + err + '] ' : ' '
  Util.log(str)
}


function Tail(host, initialLines) {
  this.host         = host || 'all'
  this.initialLines = initialLines
  this.tailing      = false
}
Util.inherits(Tail, Events.EventEmitter)


// Call this to start tailing
Tail.prototype.start = function() {
  if (this.tailing)
    return

  if (this.host == 'all') {
    this.tailAllLogFiles()
  } else {
    var logFile = config.logsDir + '/' + this.host + '.log'
    this.tailFile(logFile)
  }
  this.tailing = true
}


// Call this to end tailing
Tail.prototype.stop = function() {
  log('Stopped tailing')
  this.tailing = false
}


// -- Tail log files --

// Tail all log files from the logs directory
Tail.prototype.tailAllLogFiles = function() {
  var tail = this
  fs.readdirSync(config.logsDir)
    .filter(function(filename) {
      return /\.log$/.test(filename)
    })
    .map(function(filename) {
      return config.logsDir + '/' + filename
    })
    .forEach(function(filename) {
      var host = path.basename(filename, '.log')
      tail.tailFile(filename, host)
    })
}

// This function dumps the end of the existing log file, and then starts
// watching for changes.
Tail.prototype.tailFile = function(filename, host) {
  log('Tailing ' + filename)
  var tail      = this
  var stream    = fs.createReadStream(filename, { encoding: 'utf8' })
  var lines     = []
  var buffer    = ''
  var position  = 0
  stream.on('data', function(chunk) {
    buffer += chunk
    // Parse stream into lines and keep the last INITIAL_LINES in memory.
    // Make sure position points to the last byte in the file, or the first
    // byte of the last incomplete line.
    var match
    while (match = buffer.match(/^.*\n/)) {
      var line = match[0]
      lines.push(line.slice(0, -1))
      position += line.length
      buffer    = buffer.slice(line.length)
    }
    lines = lines.slice(-this.initialLines)
  })
  stream.on('end', function() {
    // Dump the tail of the log to the console and start watching for changes.
    //for (var i = 0; i < lines.length ; ++i)
    for (var i in lines)
      tail.emit('line', host, lines[i])
    tail.watchFile(filename, host, position)
  })
  stream.on('error', function(error) {
    log('Error tailing ' + filename, error)
    tail.emit('error', new Error("Cannot tail ' + filename + ', start server and try again"))
  })
}


// Watch file for changes.
//
// When Katon appends to file we get a change event
// and read from previous position forward.
//
// filename - Filename
// host     - Host name
// position - Position in file to start streaming from
Tail.prototype.watchFile = function(filename, host, position) {
  var tail      = this
  var streaming = false
  try {
    var watcher = fs.watch(filename, { persistent: false }, function() {
      if (!tail.tailing) {
        watcher.close()
        return
      }
      if (streaming)
        return

      var stats = fs.statSync(filename)
      if (stats.size < position) {
        // File got truncated need to adjust position to new end of file
        position = stats.size
      } else if (stats.size > position) {
        streaming = true
        tail.tailStream(filename, host, position, function(newPosition) {
          position  = newPosition
          streaming = false
        })
      }
    })
  } catch (error) {
    log('Error tailing ' + filename, error)
    tail.emit('error', new Error('Cannot tail ' + filename + ', start server and try again'))
  }
}


// Tail the end of the stream from the previous position.
//
// filename - Filename
// host     - Host name
// position - Position in file to start streaming from
// callback - Called on completion with new position (one argument)
Tail.prototype.tailStream = function(filename, host, position, callback) {
  var tail          = this
  var streamOptions = {
    start:    position,
    encoding: 'utf8'
  }
  var stream        = fs.createReadStream(filename, streamOptions)
  var lastLine      = ''
  stream.on('data', function(chunk) {
    var buffer = lastLine + chunk
    var lines  = buffer.split(/\n/)
    lastLine   = lines.pop()
    for (var i in lines) {
      var line = lines[i]
      tail.emit('line', host, line)
      position += line.length + 1
    }
  })
  stream.on('end', function() {
    callback(position)
  })
}


module.exports = Tail
