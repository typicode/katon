httpProxy = require 'http-proxy'

module.exports.load = (proxyTable) ->
  @server?.close()

  @server = httpProxy.createServer
    hostnameOnly: true
    router: proxyTable

  @server.listen 4000

