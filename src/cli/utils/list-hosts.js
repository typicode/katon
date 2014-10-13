var fs      = require('fs')
var mkdirp  = require('mkdirp')
var config  = require('../../config.js')

module.exports = function() {
  mkdirp.sync(config.hostsDir)

  return fs.readdirSync(config.hostsDir)
}
