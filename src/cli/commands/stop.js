var chalk     = require('chalk')
var launchctl = require('../utils/launchctl')
var config    = require('../../config.js')

module.exports = function() {
  console.log(chalk.red('Stopping katon daemon'))
  launchctl.remove(config.daemonPlistPath)
  console.log(chalk.red('Done'))
}