var fs         = require('fs')
var chalk      = require('chalk')
var path       = require('path')
var pathToHost = require('../utils/path-to-host')
var config     = require('../../config.js')


// Number of lines to show from end of log.
var INITIAL_LINES = 10


// Tail the end of the stream from the previous position.  When done, go back
// to watching the file for changes.
function tailStream(filename, prefix, position) {
  var streamOptions = {
    start:    position,
    encoding: 'utf-8'
  }
  var stream = fs.createReadStream(filename, streamOptions)

  var lastLine = ''
  stream.on('data', function(chunk) {
    var buffer = lastLine + chunk
    var lines  = buffer.split(/\n/)
    lastLine   = lines.pop()
    for (var i in lines) {
      var line = lines[i] + '\n'
      process.stdout.write(prefix + line)
      position += line.length
    }
  })

  stream.on('end', function() {
    watchFile(filename, prefix, position)
  })
  stream.on('error', function(error) {
    watchFile(filename, prefix, position)
  })
}


// Watch file for changes.  When Katon appends to file we get a change event
// and read from previous position forward.
function watchFile(filename, prefix, position) {
  try {
    var watcher = fs.watch(filename, function(event) {
      var stats = fs.statSync(filename)
      if (stats.size < position) {
        // File got truncated need to adjust position to new end of file
        position = stats.size
      } else if (stats.size > position) {
        // File has more content, stop watching while we tail the stream
        watcher.close()
        tailStream(filename, prefix, position)
      }
    })
  } catch (error) {
    console.log(chalk.red("Cannot tail %s, start server and try again"), filename)
    process.exit(1)
  }
}


// This function dumps the end of the existing log file, and then starts
// watching for changes.
function tailFile(filename, prefix) {
  var stream    = fs.createReadStream(filename, 'utf-8')
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
      lines.push(line)
      position += line.length
      buffer    = buffer.slice(line.length)
    }
    lines = lines.slice(-INITIAL_LINES)
  })
  stream.on('end', function() {
    // Dump the tail of the log to the console and start watching for changes.
    //for (var i = 0; i < lines.length ; ++i)
    for (var i in lines)
      process.stdout.write(prefix + lines[i])
    watchFile(filename, prefix, position)
  })
  stream.on('error', function(error) {
    console.log(chalk.red("Cannot tail %s, start server and try again"), filename)
    process.exit(1)
  })
}


// Tail all log files from the logs directory
function tailAllLogFiles()
{
  fs.readdirSync(config.logsDir)
    .filter(function(filename) {
      return /\.log$/.test(filename)
    })
    .map(function(filename) {
      return config.logsDir + '/' + filename
    })
    .forEach(function(filename) {
      var basename = path.basename(filename, '.log')
      var prefix   = chalk.blue('[' + basename + ']  ')
      tailFile(filename, prefix)
    })
}


module.exports = function(args) {
  var host    = args[0] || pathToHost(process.cwd())
  var logFile = config.logsDir + '/' + host + '.log'

  if (host == 'all')
    tailAllLogFiles()
  else
    tailFile(logFile, '')
}
