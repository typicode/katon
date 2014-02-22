logme = require 'logme'
httpProxy = require 'http-proxy'
util = require './util'

module.exports =
  paths: []

  reload: (router) ->
    util.log "Reload with #{JSON.stringify(router, null, 2)}"
    @server?.close()

    @server = httpProxy.createServer
      hostnameOnly: true
      router: router

    @server.listen 4000

  add: (path) ->
    util.log "Add #{path}"
    @paths.push path
    router = util.getRouter @paths
    @reload router
    util.getPorts(@paths)[path]

  remove: (path) ->
    util.log "Remove #{path}"
    index = @paths.indexOf path
    @paths[index] = null
    router = util.getRouter @paths
    @reload router
