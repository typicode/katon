require 'shelljs/global'
fs = require 'fs'
forever = require 'forever-monitor'

# Runs express apps
module.exports =

  forever: forever

  nodemonPath: 'nodemon'

  staticPath: 'static'

  start: (path, port) ->
    console.log "Starting #{path} port: #{port}"
    @forever.start @getCommand(path).split(' '), @getForeverOptions(path, port)

  getForeverOptions: (path, port) ->
    sourceDir: path
    max: 1
    silent: false
    outFile: "#{path}/katon.logs"
    env:
      PORT: port

  getCommand: (path) ->
    if test '-e', "#{path}/.katon"
      cat "#{path}/.katon"
    else if test '-e', "#{path}/package.json"
      pkg = JSON.parse(fs.readFileSync "#{path}/package.json")
      start = pkg.scripts?.start
      main = pkg.main
      if start?
        if which('nodemon')?
          start.replace 'node', 'nodemon'
        else
          start
      else if main?
        if which('nodemon')?
          "nodemon #{main}"
        else
          "node #{main}"
    else 
      'static'