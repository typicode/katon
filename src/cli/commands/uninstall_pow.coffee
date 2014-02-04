emitter = require '../util/emitter'
shell = require '../util/shell'

module.exports = ->
  emitter.emit 'info', 'Uninstalling Pow'
  shell.exec 'curl get.pow.cx/uninstall.sh | sh', silent: false