var isRoot    = require('is-root')
var sh        = require('shelljs')
var rmrf      = require('rimraf')
var chalk     = require('chalk')
var launchctl = require('../utils/launchctl')
var config    = require('../../config.js')

module.exports = function() {
  if (!isRoot()) {
    return console.log(chalk.red('katon uninstall requires root privileges'))
  }

  console.log(chalk.red('Uninstalling katon'))

  // Remove domain resolver
  rmrf.sync(config.resolverPath)
  
  // Remove firewall
  var result = sh.exec('pfctl -a com.apple/250.KatonFirewall -F nat', { silent: true })
  if (result.code !== 0) {
    console.log(result.output)
  }

  launchctl.remove(config.firewallPlistPath)
  
  console.log(chalk.red('Done'))
}
