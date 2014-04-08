http      = require 'http'
httpProxy = require 'http-proxy'
chalk     = require 'chalk'
util      = require './util'
apps      = require '../apps/'
config    = require '../../config'

module.exports =
  log: (str) ->
    console.log chalk.yellow('[proxy]'), str

  getDomain: (host) ->
    host.split('.').slice(-2).pop()

  start: ->
    proxy = httpProxy.createProxyServer()

    server = http.createServer (req, res) =>
      host = req.headers.host
      @log "Received request for #{host}"

      domain = util.getDomain host
      port   = apps.findByDomain(domain).port
      @log "Forwarding to http://127.0.0.1:#{port}"

      proxy.web req, res, target: "http://127.0.0.1:#{port}"

    server.listen config.proxyPort, =>
      @log "Listening on port #{config.proxyPort}"