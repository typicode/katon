fs = require 'fs'
emitter = require '../util/emitter'

module.exports = ->
  helpPath = "#{__dirname}/../../../doc/help.txt"
  emitter.emit 'log', fs.readFileSync(helpPath, 'utf8')