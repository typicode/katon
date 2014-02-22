respawn = require 'respawn'
util = require './util'

module.exports =
  monitors: {}

  add: (path, port) ->
    monitor = respawn util.getRespawnArgs path, port
    @monitors[path] = monitor
    monitor.on 'stdout', (data) -> util.log path, data
    monitor.on 'stderr', (data) -> util.log path, data
    monitor.start()
    monitor

  remove: (path) ->
    monitor = @monitors[path]
    monitor.stop()
    delete @monitors[path]
    monitor
    
  