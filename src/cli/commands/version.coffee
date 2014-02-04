pkg = require '../../../package.json'
emitter = require '../util/emitter'

module.exports = ->
  emitter.emit 'log', pkg.version