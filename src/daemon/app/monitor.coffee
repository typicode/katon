respawn = require 'respawn'
config = require '../config'
command = require './command'
env = require './env'

module.exports =

  create: (path, port) ->
    mon = respawn
      env: env.get path, port
      command: command.get path, port
      cwd: path
      maxRestarts: -1
      sleep: 10*1000

    mon.on 'stdout', (data) ->
      util.append "#{path}/katon.log", data

    mon.on 'stderr', (data) ->
      util.error path, data.toString()
      util.append "#{path}/katon.log", data

    mon