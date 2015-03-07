var fs         = require('fs')
var path       = require('path')
var chalk      = require('chalk')
var touch      = require('touch')
var pathToHost = require('../utils/path-to-host')
var config     = require('../../config')

module.exports = function(args) {
  var host = args[0] || pathToHost(process.cwd())
  var file = config.hostsDir + '/' + host + '.json'
  if (fs.existsSync(file)) {
    touch.sync(file)
    console.log('%s has been successfully stopped', chalk.cyan(host))
    console.log('To restart simply go to http://%s.ka', host)
  } else {
    console.log("Can\'t find %s, use katon list", chalk.red(host))
  }
}
