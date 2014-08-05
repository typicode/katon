var fs       = require('fs')
var path     = require('path')
var tildify  = require('tildify')
var chalk    = require('chalk')
var config   = require('../../config')

module.exports = function(dir) {
  dir = dir || process.cwd()

  var host = path.basename(dir)
  var file = config.hostsDir + '/' + host + '.json'
  if (fs.existsSync(file)) fs.unlinkSync(file)
  
  console.log("Sucessfully removed %s", chalk.cyan(tildify(dir)))
}