require 'shelljs/global'
forever = require 'forever-monitor'

# Runs express apps
module.exports =

  forever: forever

  # Starts server with a full path and port
  start: (path, port) ->
    console.log "Starting #{path} port: #{port}"
    cd path
    try
      @forever.start ['npm', 'start'],
        max: 1
        silent: false
        watch: true
        watchDirectory: path
        watchIgnoreDotFiles: true
        outFile: "#{path}/katon.logs"
        env:
          PORT: port
    catch error
      console.log error
