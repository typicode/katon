require 'shelljs/global'
forever = require 'forever-monitor'

# Runs express apps
module.exports =

  forever: forever

  start: (path, port) ->
    cd path
    @forever.start ['npm', 'start'],
      max: 1
      silent: false
      env:
        PORT: port
