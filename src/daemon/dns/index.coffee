dns    = require 'native-dns'
chalk  = require 'chalk'
config = require '../../config'

log = (str) ->
  console.log chalk.magenta('[dns]  '), str

error = (str) ->
  console.log chalk.red('[dns]  '), str

module.exports =

  start: ->
    server = dns.createServer()

    server.on 'request', (req, res) ->
      name = req.question[0].name

      log "Received request for #{name}"

      res.answer.push dns.A
        name: name
        address: '127.0.0.1'
        ttl: 600

      res.send()

    server.on 'error', (err) ->
      error err.stack

    server.serve config.dnsPort, ->
      log "Listening on port #{config.dnsPort}"