fs     = require 'fs'
_      = require 'lodash'
config = require '../../config'
App    = require '../app/'
util   = require '../app/util'

module.exports =

  list: {}

  port: config.proxyPort

  add: (path) ->
    if fs.existsSync fs.readlinkSync path
      @port += 1
      util.log path, "Start #{path} on port #{@port}"
      app = App.create path, @port
      @list[path] = app
      util.log path, "Starting `#{app.monitor.command.join ' '}`"
      app.monitor.start()

  remove: (path) ->
    console.log "Stop #{path}"
    app = @list[path]
    app.monitor.stop()
    delete @list[path]

  findByDomain: (domain) ->
    _.find @list, name: domain