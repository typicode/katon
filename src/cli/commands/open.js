var path       = require('path')
var open       = require('opn')
var chalk      = require('chalk')
var pathToHost = require('../utils/path-to-host')

// open [name]
module.exports = function(args) {
  var host = args[0] || pathToHost(process.cwd())
  var url  = 'http://' + host + '.ka/'

  console.log('Opening', chalk.cyan(url))
  open(url)
}
