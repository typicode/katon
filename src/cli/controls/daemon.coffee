common = require '../common'
config = require '../../config'

module.exports =

  path: config.daemonPlist

  create: ->
    content = common.render 'katon.plist.eco'
    common.create @path, content, mode: 33188

  remove: ->
    common.remove @path

  load: ->
    common.load @path

  unload: ->
    common.unload @path
