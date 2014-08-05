var isRoot    = require('is-root')
var chalk     = require('chalk')
var launchctl = require('../utils/launchctl')
var render    = require('../utils/render')
var config    = require('../../config.js')

module.exports = function() {
  if (!isRoot()) {
    return console.log(chalk.red('katon install requires root privileges'))
  }

  console.log(chalk.green('Installing katon'))

  // Create domain resolver
  render('resolver', config.resolverPath)

  // Create and load firewall plist
  launchctl.create('katon.firewall.plist', config.firewallPlistPath)
  
  console.log(chalk.green('Done'))
}