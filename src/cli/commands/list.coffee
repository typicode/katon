require 'shelljs/global'
emitter = require '../util/emitter'
config = require '../config'

module.exports = ->
  emitter.emit 'info', 'Linked apps'
  for link in ls "#{config.katonPath}"
    target = exec(
      "readlink #{config.katonPath}/#{link}"
      silent: true
    )
    .output
    .trim()

    if test '-d', target
      emitter.emit 'info', "#{link}: #{target} > http://#{link}.dev"
    else
      emitter.emit 'warn', "#{link}: #{target} doesn't exist"
