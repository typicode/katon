chalk  = require 'chalk'
common = require '../common'

module.exports =

  create: (path, str) ->
    console.log chalk.grey "create  `#{str}` to ./.katon"
    common.create "#{path}/.katon", str

  remove: (path) ->
    common.remove "#{path}/.katon"