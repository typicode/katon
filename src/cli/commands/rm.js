var fs       = require('fs')
var path     = require('path')
var chalk    = require('chalk')
var config   = require('../../config')

// rm [name]
module.exports = function(args) {
  var host = args[0] || path.basename(process.cwd())
  var file = config.hostsDir + '/' + host + '.json'
  if (fs.existsSync(file)) {
    fs.unlinkSync(file)
    console.log("Sucessfully removed %s", chalk.cyan(host))
  } else {
    console.log("Can\'t find %s, use katon list", chalk.red(host))
  }
}