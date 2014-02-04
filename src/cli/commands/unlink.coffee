emitter = require '../util/emitter'
shell = require '../util/shell'
config = require '../config'

module.exports =  (pathOrName) ->
  name = pathOrName.split('/').pop()
  shell.exec "rm -f #{config.powPath}/#{name} #{config.katonPath}/#{name}"
  emitter.emit 'info', "Successfully removed #{name}"