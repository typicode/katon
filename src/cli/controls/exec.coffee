chalk  = require 'chalk'
common = require '../common'

module.exports =

  create: (path, str) ->
    common.create "#{path}/.katon", str

  remove: (path) ->
    common.remove "#{path}/.katon"