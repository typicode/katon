var path      = require('path')
var mkdirp    = require('mkdirp')
var chalk     = require('chalk')
var launchctl = require('../utils/launchctl')
var config    = require('../../config.js')

module.exports = function() {
  console.log(chalk.green('Starting katon daemon'))
  mkdirp.sync(path.dirname(config.hostsPath))
  launchctl.create('katon.plist', config.daemonPlistPath)
  console.log(chalk.green('Done'))
}