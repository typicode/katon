monitor = require './monitor'
util = require './util'

module.exports =

  monitors: {}

  add: (path, port) ->
    util.log path, "Start #{path} on port #{port}"
    mon = monitor.create path, port
    @monitors[path] = mon
    mon.start()
    mon

  remove: (path) ->
    util.log path, "Stop #{path}"
    mon = @monitors[path]
    mon.stop()
    delete @monitors[path]
    mon

