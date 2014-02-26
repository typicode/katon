require 'shelljs/global'
path = require 'path'
eco = require 'eco'
emitter = require '../util/emitter'
shell = require '../util/shell'
config = require '../config'

module.exports = ->
  template = cat "#{__dirname}/../../../plist/katon.plist.eco"
  plistContent = eco.render template,
    nodePath: process.execPath
    daemonPath: path.resolve "#{__dirname}/../../daemon/index"

  unless test '-d', config.launchAgentsPath
    emitter.emit 'error', "#{config.launchAgentsPath} doesn't exist"

  shell.to "#{config.launchAgentsPath}/katon.plist", plistContent
  shell.exec "launchctl load -Fw #{config.launchAgentsPath}/katon.plist"
  emitter.emit 'info', 'Katon daemon was successfully started'