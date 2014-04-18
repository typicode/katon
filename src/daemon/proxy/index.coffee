chalk           = require 'chalk'
httpProxyRouter = require 'http-proxy-router'
app             = require '../app/'
render          = require '../../render'
config          = require '../../config'

log = (str) ->
  console.log chalk.yellow('[proxy]'), str

getDomain = (host) ->
  host.split('.').slice(-2, -1).pop()

module.exports =

  start: ->
    router = httpProxyRouter.createServer()

    router.resolve = (host) ->
      log "Received request for #{host}"
      mon = app.findByName getDomain host
      port = mon?.env?.PORT

    router.on 'forward', (host, target) ->
      log "Forwarding to #{target}"

    router.proxy.on 'error', (err, req, res) ->
      if err.code is 'ECONNREFUSED'
        mon  = app.findByName getDomain host
        res.end render 'econnrefused.html.eco', mon: mon
      else
        res.end "Unknown error: #{err.code}"

    router.on 'unknown', (host, res) ->
      res.end render 'app_not_found.html.eco'

    router.listen config.proxyPort, ->
      log "Listening on port #{config.proxyPort}"