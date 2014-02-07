httpProxy = require 'http-proxy'

module.exports.reload = (proxyTable) ->
  @server?.close()

  @server = httpProxy.createServer
    hostnameOnly: true
    router: proxyTable

  @server.listen 4000

