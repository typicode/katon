respawn = require 'respawn'
config = require '../config'
command = require './command'
env = require './env'

module.exports =

  create: (path, port) ->
    respawn
      env: env.get path, port
      command: command.get path
      cwd: path
      maxRestarts: -1
      sleep: 10*1000