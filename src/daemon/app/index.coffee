logme = require 'logme'
monitor = require './monitor'
util = require './util'

module.exports =
  monitors: {}

  add: (path, port) ->
    util.log "Start #{path} on port #{port}"
    mon = monitor.create path, port

    mon.on 'stdout', (data) ->
      util.append "#{path}/katon.log", data

    mon.on 'stderr', (data) ->
      util.error path, data.toString()
      util.append "#{path}/katon.log", data

    @monitors[path] = mon
    mon.start()
    mon

  remove: (path) ->
    util.log "Stop #{path}"

    mon = @monitors[path]
    mon.stop()
    delete @monitors[path]
    mon

