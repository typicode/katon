logme = require 'logme'
respawn = require 'respawn'
util = require './util'

module.exports =
  monitors: {}

  add: (path, port) ->
    util.log "Start #{path} on port #{port}"

    options = util.getRespawnArgs path, port

    monitor = respawn options
    @monitors[path] = monitor

    monitor.on 'stdout', (data) ->
      util.append "#{path}/katon.log", data

    monitor.on 'stderr', (data) ->
      util.error path, data.toString()
      util.append "#{path}/katon.log", data

    monitor.start()
    monitor

  remove: (path) ->
    util.log "Stop #{path}"

    monitor = @monitors[path]
    monitor.stop()
    delete @monitors[path]
    monitor

