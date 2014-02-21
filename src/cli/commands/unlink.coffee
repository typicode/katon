emitter = require '../util/emitter'
shell = require '../util/shell'
config = require '../config'
parameterize = require 'parameterize'

module.exports =  (pathOrName) ->
  name = parameterize(pathOrName.split('/').pop()).replace(/_/g,'-')
  shell.exec "rm -f #{config.powPath}/#{name} #{config.katonPath}/#{name}"
  emitter.emit 'info', "Successfully removed #{name}"