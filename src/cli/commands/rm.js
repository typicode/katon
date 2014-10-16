var fs       = require('fs')
var path     = require('path')
var chalk    = require('chalk')
var config   = require('../../config')

// rm [name]
module.exports = function(args) {
  var host    = args[0] || path.basename(process.cwd())
  var conf    = config.hostsDir + '/' + host + '.json'
  var logFile = config.logsDir + '/' + host + '.log'

  // Remove log file
  if (fs.existsSync(logFile)) fs.unlinkSync(logFile)

  // Remove server conf
  if (fs.existsSync(conf)) {
    fs.unlinkSync(conf)
    console.log("Sucessfully removed %s", chalk.cyan(host))
  } else {
    console.log("Can\'t find %s, use katon list", chalk.red(host))
  }
}
