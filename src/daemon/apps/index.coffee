_      = require 'lodash'
config = require '../../config'
App    = require '../app/'
util   = require '../app/util'

module.exports =

  list: {}

  port: config.proxyPort

  add: (path) ->
    @port += 1
    util.log path, "Start #{path} on port #{@port}"
    app = App.create path, @port
    @list[path] = app
    util.log path, "Starting `#{app.monitor.command.join ' '}`"
    app.monitor.start()

  remove: (path) ->
    util.log path, "Stop #{path}"
    app = @list[path]
    app.monitor.stop()
    delete @list[path]

  findByDomain: (domain) ->
    _.find @list, name: domain