var chalk       = require('chalk')
var config      = require('../../config.js')
var fs          = require('fs')
var listHosts   = require('../utils/list-hosts')
var Tail        = require('../../daemon/utils/tail')


// Number of lines to show from end of log.
var INITIAL_LINES = 10

// Return host name for current working directory
// Directory usually, not necessarily, same as host name
function getHostName(cwd) {
  var hostNames = listHosts()
    .map(function(name) {
      var filename = config.hostsDir + '/' + name
      var host = JSON.parse(fs.readFileSync(filename))
      return [name.replace('.json', ''), host.cwd]
    })
    .filter(function(nameAndPath) {
      var path = nameAndPath[1]
      return path === cwd
    })
    .map(function(nameAndPath) {
      var name = nameAndPath[0]
      return name
    })
  return hostNames[0]
}


module.exports = function(args) {
  var host  = args[0] || getHostName(process.cwd())
  var tail  = new Tail(host, INITIAL_LINES);
  tail
    .on('line', function(prefix, line) {
      if (prefix)
        process.stdout.write(chalk.blue('[' + prefix + ']  '))
      process.stdout.write(line + '\n')
    })
    .on('error', function(error) {
      process.stderr.write(chalk.red(error.message) + '\n')
      process.exit(1)
    })
  tail.start()

  // Keep process running until Ctrl+C
  setInterval(function() {
  }, 1000)
}

