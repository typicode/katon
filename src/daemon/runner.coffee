require 'shelljs/global'
fs = require 'fs'
forever = require 'forever-monitor'

# Runs express apps
module.exports =

  forever: forever

  nodemonPath: 'node_modules/.bin/nodemon'

  staticPath: 'node_modules/.bin/static'

  start: (path, port) ->
    console.log "Starting #{path} port: #{port}"
    console.log @getCommand(path), @getForeverOptions(path, port)
    @forever.start '', @getForeverOptions(path, port)

  getForeverOptions: (path, port) ->
    command: @getCommand(path)
    options: @getOptions(path, port)
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
      if main?
        @nodemonPath
        # start.replace 'node', @nodemonPath
      else
        start.split(' ')[0]
    else 
      @staticPath

  getOptions: (path, port) ->
    if test '-e', "#{path}/.katon"
      cat "#{path}/.katon"
    else if test '-e', "#{path}/package.json"
      pkg = JSON.parse(fs.readFileSync "#{path}/package.json")
      start = pkg.scripts?.start
      main = pkg.main
      if main?
        []
      else
        [start.split(' ')[1]]
    else 
      "#{path} --port #{port}".split(' ')

#   forever: forever

#   foreverPath: 'node_modules/.bin/forever'

#   nodemonPath: 'node_modules/.bin/nodemon'

#   staticPath: 'node_modules/.bin/static'

#   start: (path, port) ->
#     console.log "Starting #{path} port: #{port}"
#     console.log path, @getCommand(path)
#     shout.exec "#{@foreverPath} start --sourceDir #{pwd()} #{@getCommand(path)} --port #{port}"

#   getCommand: (path) ->
#     if test '-e', "#{path}/.katon"
#       cat "#{path}/.katon"
#     else if test '-e', "#{path}/package.json"
#       pkg = JSON.parse(fs.readFileSync "#{path}/package.json")
#       start = pkg.scripts?.start
#       main = pkg.main
#       if main?
#         @nodemonPath
#         # start.replace 'node', @nodemonPath
#       else
#         start
#     else 
#       "#{@staticPath} #{path}"