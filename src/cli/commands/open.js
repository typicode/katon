var path       = require('path')
var minimist   = require('minimist')
var open       = require('opn')
var chalk      = require('chalk')
var pathToHost = require('../utils/path-to-host')

// open [name] --https
module.exports = function(args) {
  var args = minimist(args)
  var host = args._[0] || pathToHost(process.cwd())
  var protocol = args.https ? 'https' : 'http'
  var url  = protocol + '://' + host + '.ka/'

  console.log('Opening', chalk.cyan(url))
  open(url)
}
