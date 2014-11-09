var fs         = require('fs')
var chalk      = require('chalk')
var path       = require('path')
var config     = require('../../config.js')


// Number of lines to show from end of log.
var INITIAL_LINES = 10


// This function dumps the end of the existing log file, and then starts
// watching for changes.
function tailFile(filename) {
  var stream    = fs.createReadStream(filename, 'utf-8')
  var lines     = []
  var buffer    = ''
  var position  = 0
  stream.on('data', function(chunk) {
    buffer += chunk
    // Parse stream into lines and keep the last INITIAL_LINES in memory.
    // Make sure position points to the last byte in the file, or the first
    // byte of the last incomplete line.
    var line
    while (line = buffer.match(/^.*\n/)) {
      lines.push(line[0])
      position += line[0].length
      buffer    = buffer.slice(line[0].length)
    }
    lines = lines.slice(-INITIAL_LINES)
  })
  stream.on('end', function() {
    // Dump the tail of the log to the console and start watching for changes.
    process.stdout.write(lines.join(''))
    watchFile(filename, position)
  })
  stream.on('error', function(error) {
    console.log(chalk.red("Cannot tail %s, start server and try again"), filename)
    process.exit(1)
  })
}


// Watch file for changes.  When Katon appends to file we get a change event
// and read from previous position forward.
function watchFile(filename, position) {
  try {
    var watcher = fs.watch(filename, function(event) {
      var stats = fs.statSync(filename)
      if (stats.size < position) {
        // File got truncated need to adjust position to new end of file
        position = stats.size
      } else if (stats.size > position) {
        // File has more content, stop watching while we tail the stream
        watcher.close()
        tailStream(filename, position)
      }
    })
  } catch (error) {
    console.log(chalk.red("Cannot tail %s, start server and try again"), filename)
    process.exit(1)
  }
}


// Tail the end of the stream from the previous position.  When done, go back
// to watching the file for changes.
function tailStream(filename, position) {
  var streamOptions = {
    start:    position,
    encoding: 'utf-8'
  }
  var stream = fs.createReadStream(filename, streamOptions)
  stream.on('data', function(chunk) {
    process.stdout.write(chunk)
    position += chunk.length
  })
  stream.on('end', function() {
    watchFile(filename, position)
  })
  stream.on('error', function(error) {
    watchFile(filename, position)
  })
}


module.exports = function(args) {
  var host     = args[0] || path.basename(process.cwd())
  var logFile  = config.logsDir + '/' + host + '.log'

  tailFile(logFile)
}

