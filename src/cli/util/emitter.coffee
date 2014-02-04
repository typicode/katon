events = require 'events'
util = require 'util'

Emitter = ->
  events.EventEmitter.call @

util.inherits Emitter, events.EventEmitter

emitter = new Emitter()

module.exports = emitter