var fs     = require('fs')
var path   = require('path')
var chalk  = require('chalk')
var touch  = require('touch')
var config = require('../../config')

module.exports = function(args) {
  var host = args[0] || path.basename(process.cwd())
  var file = config.hostsDir + '/' + host + '.json'
  if (fs.existsSync(file)) {
    touch.sync(file)
    console.log('%s has been successfully reloaded', chalk.cyan(host))
  } else {
    console.log("Can\'t find %s, use katon list", chalk.red(host))
  }
}
