require 'shelljs/global'
fs = require 'fs'
httpProxy = require 'http-proxy'
forever = require 'forever-monitor'

apps = {}
router = {}
proxyServer = null

stopAll = ->
  for app in apps
    app.stop()
    delete apps[app]

startAll = ->
  for path, index in ls "#{env.HOME}/.katon"
    port = 4001 + index
    app = runner.start path, port
    router["#{path}.dev"] = "127.0.0.1:#{port}" 

stopProxy = ->
  proxyServer.close() if proxyServer

startProxy = ->
  proxyServer = httpProxy.createServer(hostnameOnly: true, router: router)
  proxyServer.listen(4000);

reload = ->
  stopProxy()
  stopAll()
  startAll()
  startProxy()

fs.watch "#{env.HOME}/.katon", reload