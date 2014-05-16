common = require '../common'
config = require '../../config'

module.exports =

  path: config.firewallPlist

  create: ->
    content = common.render 'katon.firewall.plist.eco'
    common.create @path, content

  remove: ->
    common.remove @path

  load: ->
    common.load @path

  unload: ->
    common.unload @path

  deleteRule: ->
    common.sh "ipfw del #{config.ruleNumber}"
