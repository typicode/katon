require 'shelljs/global'
fs = require 'fs'

# Runs express apps
module.exports =

  foreverPath: 'node_modules/.bin/forever'

  nodemonPath: 'node_modules/.bin/nodemon'

  staticPath: 'node_modules/.bin/static'

  start: (path, port) ->
    console.log "Starting #{path} port: #{port}"
    console.log path, @getCommand(path)
    shout.exec "#{@foreverPath} start --sourceDir #{pwd()} #{@getCommand(path)} --port #{port}"

  getCommand: (path) ->
    if test '-e', "#{path}/.katon"
      cat "#{path}/.katon"
    else if test '-e', "#{path}/package.json"
      pkg = JSON.parse(fs.readFileSync "#{path}/package.json")
      start = pkg.scripts?.start
      main = pkg.main
      if main?
        start.replace 'node', @nodemonPath
      else
        start
    else 
      "#{@staticPath} #{path}"