var assert = require('assert')
var fs     = require('fs')
var rmrf   = require('rimraf')
var mkdirp = require('mkdirp')

// Some configs depends on HOME, it must be changed before requiring config
var tmp    = process.env.HOME = __dirname + '/../tmp'
var config = require('../src/config')

config.resolverPath      = tmp + config.resolverPath
config.firewallPlistPath = tmp + config.firewallPlist

config.dnsPort   = 50100
config.httpPort = 50200

// Setup paths so that everything is written to tmp
module.exports = function() {
  rmrf.sync(tmp)
  mkdirp.sync(tmp + '/etc/resolver')
  mkdirp.sync(tmp + '/Library/LaunchDaemons')
  mkdirp.sync(tmp + '/Library/LaunchAgents')
}