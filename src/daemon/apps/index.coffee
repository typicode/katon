fs         = require 'fs'
p          = require 'path'
regroup    = require 'respawn-group'
chalk      = require 'chalk'
portfinder = require 'portfinder'
log        = require './log'
env        = require './env'
command    = require './command'
config     = require '../../config'

port = config.proxyPort

group = regroup()

group.on 'start', (mon) ->
  log.global.log mon.cwd, "Start #{mon.cwd} on port #{mon.env.PORT}"

group.on 'stop', (mon) ->
  log.daemon.log mon.cwd, "Stop #{mon.cwd}"

group.on 'spawn', (mon) ->
  log.daemon.log mon.cwd, 'Spawn'

group.on 'stdout', (mon, data) -> log.app.plain mon.cwd, data
group.on 'stderr', (mon, data) -> log.app.plain mon.cwd, data

module.exports =

  add: (path) ->
    portfinder.basePort port
    portfinder.getPort (err, openPort)->
      if err
        new Error("Problem finding a port: #{err}")
      else
        port = openPort

    group.add path,
      env         : env.get path, port
      command     : command.get path, port
      cwd         : path
      maxRestarts : -1
      sleep       : 10*1000

    group.start path

  remove: (path) ->
    group.remove path

  findByName: (name) ->
    group.get "#{config.katonDir}/#{name}"
