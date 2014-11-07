var util  = require('util')
var dns   = require('native-dns')
var chalk = require('chalk')

function log(str) {
  util.log(chalk.magenta('[dns   ] ') + chalk.grey(str))
}

module.exports.createServer = function() {

  var server = dns.createServer()

  server.on('request', function(request, response) {
    var name = request.question[0].name
  	
    response.answer.push(dns.A({
      name: name,
      address: '127.0.0.1',
      ttl: 600
    }))

    response.send()
    log('Resolved ' + name)
  })

  server.on('error', function (err, buff, req, res) {
    console.log(err.stack)
  })

  return server
}