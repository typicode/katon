http      = require 'http'
httpProxy = require 'http-proxy'
chalk     = require 'chalk'
app       = require '../app/'
render    = require '../../render'
config    = require '../../config'

log = (str) ->
  console.log chalk.yellow('[proxy]'), str

getDomain = (host) ->
  host.split('.').slice(-2, -1).pop()

module.exports =

  start: ->
    proxy = httpProxy.createProxyServer()

    proxy.on 'error', (err, req, res) ->
      if err.code is 'ECONNREFUSED'
        host = req.headers.host
        mon  = app.findByName getDomain host
        res.end render 'econnrefused.html.eco', mon: mon
      else
        res.end "Unknown error: #{err.code}"

    server = http.createServer (req, res) ->
      host = req.headers.host
      log "Received request for #{host}"

      name = getDomain host

      if mon = app.findByName name
        port = mon.env.PORT
        log "Forwarding to http://127.0.0.1:#{port}"
        proxy.web req, res, target: "http://127.0.0.1:#{port}"
      else
        res.end render 'app_not_found.html.eco'

    server.listen config.proxyPort, ->
      log "Listening on port #{config.proxyPort}"