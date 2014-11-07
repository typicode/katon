var path    = require('path')
var sh      = require('shelljs')
var mkdirp  = require('mkdirp')
var chalk   = require('chalk')
var render  = require('../utils/render')
var version = require('../utils/osx-minor-version')
var config  = require('../../config.js')

sh.config.silent = true

module.exports = function() {
  console.log(chalk.green('Starting katon daemon'))

  mkdirp.sync(path.dirname(config.hostsDir))
  
  // Create and load daemon plist
  render('katon.plist', config.daemonPlistPath, { mode: 33188 })

  if (version() >= 10) {
    var UID = process.getuid()
    sh.exec('launchctl bootstrap gui/' + UID + ' ' + config.daemonPlistPath)
    sh.exec('launchctl enable gui/' + UID + '/katon')
    sh.exec('launchctl kickstart -k gui/' + UID + '/katon')
  } else {
    sh.exec('launchctl unload ' + config.daemonPlistPath)
    sh.exec('launchctl load -Fw ' + config.daemonPlistPath)
  }

  // Done
  console.log(chalk.green('Done'))
}
