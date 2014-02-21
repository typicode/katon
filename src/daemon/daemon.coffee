proxy = require 'proxy'
processes = require 'processes'

katonPath = "#{process.env.HOME}/.katon"

module.exports = 
  add: (path) ->
    port = proxy.add path
    process.add path, port

  remove: (path) ->
    proxy.remove path
    process.remove path

  init: ->
    for name in fs.readdir katonPath
      @add "#{katonPath}/#{name}"

  watch: ->
    fs.watch katonPath, (event, filename) ->
      if fs.existsSync "#{katonPath}/#{filename}"
        @add filename
      else
        @remove filename