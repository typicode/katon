emitter = require '../util/emitter'
shell = require '../util/shell'
config = require '../config'

module.exports = (path, execString) ->
  name = path.split('/').pop().replace /_/g, '-'

  shell.exec "open http://#{name}.dev"