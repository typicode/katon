monitor = require './monitor'
util    = require './util'

module.exports =

  create: (path, port) ->
    path    : path
    port    : port
    name    : util.getName path
    monitor : monitor.create path, port