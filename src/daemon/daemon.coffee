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
    if not (app.add path, port)?
      console.error "Failed to add app"
      proxy.remove path

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