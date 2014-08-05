var fs      = require('fs')
var mkdirp  = require('mkdirp')
var chalk   = require('chalk')
var tildify = require('tildify')
var config  = require('../../config.js')

module.exports = function() {
  mkdirp.sync(config.hostsDir)

  fs.readdirSync(config.hostsDir).forEach(function(name) {
    var filename = config.hostsDir + '/' + name
    var host = JSON.parse(fs.readFileSync(filename))

    console.log(
      chalk.cyan(name.replace('.json', '')),
      host.command,
      chalk.grey(tildify(host.cwd))
    )
  }) 
}