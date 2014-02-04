require 'shelljs/global'
emitter = require '../util/emitter'

module.exports = ->
  if which('pow')?
    emitter.emit 'info', 'Pow installed'
  else
    emitter.emit 'warn', 'Pow not installed, try katon install-pow'

  if exec('launchctl list | grep katon', silent: true).output is ''
    emitter.emit 'warn', 'Katon daemon stopped, try katon start'
  else
    emitter.emit 'info', 'Katon daemon started'