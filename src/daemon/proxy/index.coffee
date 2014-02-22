httpProxy = require 'http-proxy'
util = require './util'

module.exports =
  paths: []

  reload: (router) ->
    @server?.close()

    @server = httpProxy.createServer
      hostnameOnly: true
      router: router

    @server.listen 4000

  add: (path) ->
    @paths.push path
    router = util.getRouter @paths
    @reload router
    util.getPorts(@paths)[path]

  remove: (path) ->
    index = @paths.indexOf path
    @paths[index] = null
    router = util.getRouter @paths
    @reload router
