http      = require 'http'
httpProxy = require 'http-proxy'
chalk     = require 'chalk'
app       = require '../app/'
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
        res.end """
          Can't connect to app.
          
          Check katon.log:
          $ tail -n 200 -f #{mon.cwd}/katon.log

          Check link:
          $ katon list

          Check that app is listening on the right port:
          http://localhost:#{mon.env.PORT}/

          For more information, see:
          https://github.com/typicode/katon
        """
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
        res.end """
          Can't find app #{name}.

          Try linking it again using katon CLI.

          From your app directory:
          $ katon unlink
          $ katon link
        """

    server.listen config.proxyPort, ->
      log "Listening on port #{config.proxyPort}"