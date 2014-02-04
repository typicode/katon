require 'shelljs/global'
eco = require 'eco'
emitter = require '../util/emitter'
shell = require '../util/shell'
config = require '../config'

module.exports = ->
  shell.exec "launchctl unload #{config.launchAgentsPath}/katon.plist"
  shell.rm "#{config.launchAgentsPath}/katon.plist"
  emitter.emit 'info', 'Katon daemon was successfully stopped'