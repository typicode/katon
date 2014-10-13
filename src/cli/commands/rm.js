var fs       = require('fs')
var path     = require('path')
var chalk    = require('chalk')
var config   = require('../../config')

// rm [name]
module.exports = function(args) {
  var host = args[0] || path.basename(process.cwd())
  var conf = config.hostsDir + '/' + host + '.json'
  var log  = config.logsDir + '/' + host + '.log'
  if (fs.existsSync(conf)) {
    fs.unlinkSync(conf)
    if (fs.existsSync(log)) fs.unlinkSync(log)
    console.log("Sucessfully removed %s", chalk.cyan(host))
  } else {
    console.log("Can\'t find %s, use katon list", chalk.red(host))
  }
}