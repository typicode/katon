var util  = require('util')
var dns   = require('dnsjack')
var chalk = require('chalk')

function log(str) {
  util.log(chalk.magenta('[dns   ] ') + chalk.grey(str))
}

module.exports.createServer = function() {

  var server = dns.createServer()

  server.route('*', function(domain, cb) {
    cb(null, '127.0.0.1')
  })

  server.on('resolve', function(domain) {
    log("Resolving " + domain)
  })

  return server
}
