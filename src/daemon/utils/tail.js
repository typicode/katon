var Events      = require('events')
var fs          = require('fs')
var path        = require('path')
var config      = require('../../config.js')
var Util        = require('util')


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
      var prefix = path.basename(filename, '.log')
      tail.tailFile(filename, prefix)
    })
}

// This function dumps the end of the existing log file, and then starts
// watching for changes.
Tail.prototype.tailFile = function(filename, prefix) {
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
    for (var i in lines) {
      tail.emit('line', prefix, lines[i])
    }
    if (tail.tailing)
      tail.watchFile(filename, prefix, position)
  })
  stream.on('error', function(error) {
    tail.emit('error', new Error("Cannot tail ' + filename + ', start server and try again"))
  })
}


// Watch file for changes.  When Katon appends to file we get a change event
// and read from previous position forward.
Tail.prototype.watchFile = function(filename, prefix, position) {
  var tail = this
  try {
    var watcher = fs.watch(filename, function(event) {
      if (!tail.tailing)
        return

      var stats = fs.statSync(filename)
      if (stats.size < position) {
        // File got truncated need to adjust position to new end of file
        position = stats.size
      } else if (stats.size > position) {
        // File has more content, stop watching while we tail the stream
        watcher.close()
        tail.tailStream(filename, prefix, position)
      }
    })
  } catch (error) {
    tail.emit('error', new Error('Cannot tail ' + filename + ', start server and try again'))
  }
}


// Tail the end of the stream from the previous position.  When done, go back
// to watching the file for changes.
Tail.prototype.tailStream = function(filename, prefix, position) {
  var tail          = this
  var streamOptions = {
    start:    position,
    encoding: 'utf8'
  }
  var stream        = fs.createReadStream(filename, streamOptions)
  var lastLine      = ''
  stream.on('data', function(chunk) {
    if (!tail.tailing) {
      stream.close()
      return
    }

    var buffer = lastLine + chunk
    var lines  = buffer.split(/\n/)
    lastLine   = lines.pop()
    for (var i in lines) {
      var line = lines[i]
      tail.emit('line', prefix, line)
      position += line.length + 1
    }
  })

  stream.on('end', function() {
    tail.watchFile(filename, prefix, position)
  })
  stream.on('error', function(error) {
    tail.watchFile(filename, prefix, position)
  })
}


module.exports = Tail
