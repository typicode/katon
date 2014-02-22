fs = require 'fs'
proxy = require './proxy'
app = require './app'

katonPath = "#{process.env.HOME}/.katon"

module.exports =
  add: (path) ->
    port = proxy.add path
    app.add path, port

  remove: (path) ->
    proxy.remove path
    app.remove path

  init: ->
    for name in fs.readdirSync katonPath
      @add "#{katonPath}/#{name}"

  watch: ->
    fs.watch katonPath, (event, filename) ->
      if fs.existsSync "#{katonPath}/#{filename}"
        @add filename
      else
        @remove filename