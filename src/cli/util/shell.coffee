require 'shelljs/global'
emitter = require '../util/emitter'

module.exports.to = (file, string) ->
  string.to file
  if string.length > 10
    emitter.emit 'debug', "echo ... > #{file}"
  else
    emitter.emit 'debug', "echo #{string} > #{file}"

module.exports.mkdir = (dir) ->
  mkdir dir
  emitter.emit 'debug', "mkdir #{dir}"

module.exports.rm = (file) ->
  rm file
  emitter.emit 'debug', "rm #{file}"

module.exports.exec = (command, options = silent: true) ->
  res = exec command, options
  emitter.emit 'debug', command
  if res.code > 0
    emitter.emit 'error', res.output