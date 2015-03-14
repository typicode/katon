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
  this.logFiles     = null
}
Util.inherits(Tail, Events.EventEmitter)


// Call this to start tailing
Tail.prototype.start = function() {
  if (this.logFiles)
    return

  if (this.host == 'all') {
    this.logFiles = this.tailAllLogFiles()
  } else {
    var filename  = config.logsDir + '/' + this.host + '.log'
    var logFile   = new LogFile(this, filename, this.host)
    logFile.start()
    this.logFiles = [ logFile ]
  }
}


// Call this to end tailing
Tail.prototype.stop = function() {
  log('Stopped tailing')
  this.logFiles.forEach(function(logFile) {
    logFile.stop()
  })
}


// -- Tail log files --

// Tail all log files from the logs directory
Tail.prototype.tailAllLogFiles = function() {
  var tail = this
  var logFiles = fs
    .readdirSync(config.logsDir)
    .filter(function(filename) {
      return /\.log$/.test(filename)
    })
    .map(function(filename) {
      return config.logsDir + '/' + filename
    })
    .map(function(filename) {
      var host    = path.basename(filename, '.log')
      var logFile = new LogFile(tail, filename, host)
      logFile.start()
      return logFile
    })
  return logFiles
}


// Maintains state for each log file
function LogFile(tail, filename, host) {
  this.filename     = filename
  this.host         = host
  this.position     = 0
  this.initialLines = tail.initialLines
  this.emit         = tail.emit.bind(tail)
}


LogFile.prototype.start = function() {
  var logFile   = this
  log('Tailing ' + logFile.filename)

  var stream    = fs.createReadStream(logFile.filename, { encoding: 'utf8' })
  var lines     = []
  var buffer    = ''
  stream.on('data', function(chunk) {
    buffer += chunk
    // Parse stream into lines and keep the last INITIAL_LINES in memory.
    // Make sure position points to the last byte in the file, or the first
    // byte of the last incomplete line.
    var match
    while (match = buffer.match(/^.*\n/)) {
      var line = match[0]
      lines.push(line.slice(0, -1))
      logFile.position += line.length
      buffer   = buffer.slice(line.length)
    }
    lines = lines.slice(-logFile.initialLines)
  })
  stream.on('end', function() {
    // Dump the tail of the log to the console and start watching for changes.
    //for (var i = 0; i < lines.length ; ++i)
    for (var i in lines)
      logFile.emit('line', logFile.host, lines[i])
    logFile.watch()
  })
  stream.on('error', function(error) {
    log('Error tailing ' + logFile.filename, error)
    logFile.emit('error', new Error('Cannot tail ' + logFile.filename + ', start server and try again'))
  })
}


// Watch file for changes.
LogFile.prototype.watch = function() {
  var logFile   = this
  var streaming = false

  this.watcher = fs.watch(this.filename, { persistent: false }, changeEvent)

  function changeEvent() {
    if (streaming)
      return

    var stats = fs.statSync(logFile.filename)
    if (stats.size < logFile.position) {
      // File got truncated need to adjust position to new end of file
      logFile.position = stats.size
    } else if (stats.size > logFile.position) {
      streaming = true
      logFile.tailStream(function() {
        streaming = false
      })
    }
  }
}


// Tail the end of the stream from the previous position.
LogFile.prototype.tailStream = function(callback) {
  var logFile     = this
  var streamOptions = {
    start:    logFile.position,
    encoding: 'utf8'
  }
  var stream        = fs.createReadStream(logFile.filename, streamOptions)
  var lastLine      = ''
  stream.on('data', function(chunk) {
    var buffer = lastLine + chunk
    var lines  = buffer.split(/\n/)
    lastLine   = lines.pop()
    for (var i in lines) {
      var line = lines[i]
      logFile.emit('line', logFile.host, line)
      logFile.position += line.length + 1
    }
  })
  stream.on('end', callback);
}


LogFile.prototype.stop = function() {
  this.watcher.close()
}


module.exports = Tail
