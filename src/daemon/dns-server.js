var util  = require('util')
var dns   = require('native-dns')
var chalk = require('chalk')

function log(str) {
  util.log(chalk.magenta('[dns   ] ') + chalk.grey(str))
}

module.exports.createServer = function() {

  var server = dns.createServer()

  server.on('request', function(request, response) {
    var question  = request.question[0]
    var name      = question.name

    var a = dns.A({
      name: name,
      address: '127.0.0.1',
      ttl: 600
    })
    var aaaa = dns.AAAA({
      name: name,
      address: '::1',
      ttl: 600
    })

    // Answer A question with A record, AAAA with AAAA
    // record (and vice versa)
    if (question.type === dns.consts.NAME_TO_QTYPE.A)
      response.answer.push(a)
    if (question.type === dns.consts.NAME_TO_QTYPE.AAAA)
      response.answer.push(aaaa)

    response.send()
    log('Resolved ' + name)
  })

  server.on('error', function (err, buff, req, res) {
    log(err.stack)
  })

  return server
}
