respawn = require 'respawn'
config = require '../../config'
command = require './command'
env = require './env'
util = require './util'

module.exports =

  create: (path, port) ->
    respawn
      env: env.get path, port
      command: command.get path, port
      cwd: path
      maxRestarts: -1
      sleep: 10*1000

    mon.on 'stdout', (data) -> util.append path, data
    mon.on 'stderr', (data) -> util.append path, data

    mon