require 'shelljs/global'
forever = require 'forever-monitor'

# Runs express apps
module.exports =

  forever: forever

  start: (path, port) ->
    console.log "Starting #{path} port: #{port}"
    nodePath = process.argv[0]
    cd path
    try
      @forever.start [nodePath, 'app.js'],
        max: 1
        silent: false
        env:
          PORT: port
    catch error
      console.log error
