require 'shelljs/global'
fs = require 'fs'
httpProxy = require 'http-proxy'
forever = require 'forever-monitor'
runner = require './runner'

apps = {}
router = {}
proxyServer = null

stopAll = ->
  console.log "Stopping all apps"
  for app in apps
    app.stop()
    delete apps[app]

startAll = ->
  console.log "Starting all apps"
  for path, index in ls "#{env.HOME}/.katon"
    port = 4001 + index
    app = runner.start "#{env.HOME}/.katon/#{path}", port
    router["#{path}.dev"] = "127.0.0.1:#{port}" 

stopProxy = ->
  console.log "Stopping katon proxy server"
  proxyServer.close() if proxyServer

startProxy = ->
  console.log "Starting katon proxy server"
  proxyServer = httpProxy.createServer(hostnameOnly: true, router: router)
  proxyServer.listen(4000);

reload = ->
  stopProxy()
  stopAll()
  startAll()
  startProxy()

reload()
fs.watch "#{env.HOME}/.katon", reload
