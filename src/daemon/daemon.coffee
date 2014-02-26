fs = require 'fs'
chalk = require 'chalk'
proxy = require './proxy'
app = require './app'

katonPath = "#{process.env.HOME}/.katon"

module.exports =
  log: (str) ->
    console.log ' '
    console.log chalk.underline('katon', str)
    console.log ' '

  add: (path) ->
    @log "Add #{path}"
    port = proxy.add path
    try
      app.add path, port
    catch e
      console.error path, e
      setTimeout @add, 10*1000 

  remove: (path) ->
    @log "Remove #{path}"
    proxy.remove path
    app.remove path

  init: ->
    @log 'Initialize daemon'
    for name in fs.readdirSync katonPath
      @add "#{katonPath}/#{name}"

  watch: ->
    fs.watch katonPath, (event, filename) ->
      if fs.existsSync "#{katonPath}/#{filename}"
        @add filename
      else
        @remove filename