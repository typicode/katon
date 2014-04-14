common = require '../common'
config = require '../../config'
render = require '../../render'

module.exports =

  path: config.daemonPlist

  create: ->
    content = render 'katon.plist.eco', config
    common.create @path, content, mode: 33188

  remove: ->
    common.remove @path

  load: ->
    common.load @path

  unload: ->
    common.unload @path
