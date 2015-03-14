var chalk       = require('chalk')
var Tail        = require('../../daemon/utils/tail')
var pathToHost  = require('../utils/path-to-host')


// Number of lines to show from end of log.
var INITIAL_LINES = 10

module.exports = function(args) {
  var host  = args[0] || pathToHost(process.cwd())
  var tail  = new Tail(host, INITIAL_LINES);
  tail.on('error', function(error) {
    process.stderr.write(chalk.red(error.message) + '\n')
    process.exit(1)
  })
  tail.on('line', function(prefix, line) {
    if (prefix)
      process.stdout.write(chalk.blue('[' + prefix + ']  '))
    process.stdout.write(line + '\n')
  })
  tail.start()
}

