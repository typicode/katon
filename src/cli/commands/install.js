var isRoot  = require('is-root')
var chalk   = require('chalk')
var sh      = require('shelljs')
var render  = require('../utils/render')
var version = require('../utils/osx-minor-version')
var config  = require('../../config.js')

sh.config.silent = true

module.exports = function() {
  if (!isRoot()) {
    return console.log(chalk.red('katon install requires root privileges'))
  }

  console.log(chalk.green('Installing katon'))

  // Create domain resolver
  render('resolver', config.resolverPath)

  // Create and load firewall plist
  render('katon.firewall.plist', config.firewallPlistPath, { mode: 33188 })

  if (version() >= 10) {
    sh.exec('launchctl bootstrap system ' + config.firewallPlistPath)
    sh.exec('launchctl enable system/katon.firewall')
    sh.exec('launchctl kickstart -k system/katon.firewall')
  } else {
    sh.exec('launchctl load -Fw ' + config.firewallPlistPath)
  }
  
  // Done
  console.log(chalk.green('Done'))
}