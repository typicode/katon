var path       = require('path')
var open       = require('opn')
var pathToHost = require('../utils/path-to-host')

module.exports = function(dir) {
  dir = dir || process.cwd()
  var url = 'http://' + pathToHost(dir) + '.ka/'
  
  console.log('Opening ' + url)
  open(url)
}