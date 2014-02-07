_ = require 'lodash'
log = require './log'
commander = require './commander'
spawner = require './spawner'

module.exports =
  commander: commander
  spawner: spawner
  katonPath: "#{env.HOME}/.katon"
  apps: []

  getPort: ->
    if _.isEmpty @apps
      4001
    else
      _.max(@apps, 'port').port + 1

  getProxyTable: ->
    _.map @apps, (app) ->
      route = {}
      route[app.host] = "127.0.0.1:#{app.port}"
      route

  create: (name) ->
    log "Start #{name}"

    path = "#{@katonPath}/#{name}"
    port = @getPort()
    command = @commander.getCommand path, port
    process = @spawner.spawn path, command

    app = 
      name: name
      host: "#{name}.dev"
      port: port
      process: process
      stop: ->
        log "Kill #{@name}"
        @process.removeAllListeners 'exit'
        @process.kill()

    @apps.push app

    app

  remove: (name) ->
    log "Stop #{name}"

    app = _.find @apps, name: name
    @apps = _.reject @apps, name: name
    app.stop()