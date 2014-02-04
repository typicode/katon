emitter = require '../util/emitter'
shell = require '../util/shell'

module.exports = ->
  emitter.emit 'info', 'Installing Pow'
  shell.exec 'curl get.pow.cx | sh', silent: false