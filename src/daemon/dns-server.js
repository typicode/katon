// var util  = require('util')
// var dns   = require('native-dns')
// var chalk = require('chalk')
//
// function log(str) {
//   util.log(chalk.magenta('[dns   ] ') + str)
// }
//
// module.exports.createServer = function() {
//
//   var server = dns.createServer()
//
//   server.on('request', function(req, res) {
//     var name = req.question[0].name
//     log("Received request for " + name)
//     res.answer.push(dns.A({
//       name: name,
//       address: '127.0.0.1',
//       ttl: 600
//     }))
//     return res.send()
//   })
//
//   server.on('error', function(err) {
//     log(err.stack)
//   })
//
//   return server
// }

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
