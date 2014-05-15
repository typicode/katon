common = require '../common'
config = require '../../config'

module.exports =

  path: config.resolverPath

  create: ->
    content = common.render 'resolver.eco'
    common.create @path, content

  remove: ->
    common.remove @path
