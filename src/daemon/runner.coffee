require 'shelljs/global'
fs = require 'fs'
forever = require 'forever-monitor'

# Runs express apps
module.exports =

  forever: forever
  # .katon
  #   command file options
  #   command options
  #   command 

  # package
  #   main: file
  #   start: command file options

  # no package
  #   static options


  nodemon: "#{__dirname}/../../node_modules/.bin/nodemon"

  static: "#{__dirname}/../../node_modules/.bin/static"

  containsKaton: (path) ->
    test '-e', "#{path}/.katon"

  containsPackage: (path) ->
    test '-e', "#{path}/package.json"

  readPackage: (path) ->
    JSON.parse(fs.readFileSync "#{path}/package.json")

  readKaton: (path) ->
    cat "#{path}/.katon"

  getCommandLine: (path) ->
    if @containsKaton path
      @readKaton path
    else if @containsPackage path
      pkg = @readPackage path
      if pkg.main?
        @nodemon
      else
        pkg.scripts?.start
    else
      "#{@static} --port $PORT"

  commandLineToObject: (commandLine) ->
    [command, options...] = commandLine.split(' ')
    command: command
    options: options

  start: (path, port) ->
    console.log __dirname
    commandLine = @getCommandLine path
    console.log commandLine
    commandLineObject = @commandLineToObject commandLine
    console.log commandLineObject
    foreverOptions = 
      command: commandLineObject.command
      options: commandLineObject.options
      sourceDir: path
      max: 1
      silent: false
      outFile: "#{path}/katon.logs"
      env:
        PORT: port
    console.log foreverOptions
    @forever.start '', foreverOptions


  # start: (path, port) ->
  #   console.log "Starting #{path} port: #{port}"
  #   console.log @getCommand(path), @getForeverOptions(path, port)
  #   @forever.start '', @getForeverOptions(path, port)

  # getForeverOptions: (path, port) ->
  #   command: @getCommand(path)
  #   options: @getOptions(path, port)
  #   sourceDir: path
  #   max: 1
  #   silent: false
  #   outFile: "#{path}/katon.logs"
  #   env:
  #     PORT: port

  # getCommand: (path) ->
  #   if test '-e', "#{path}/.katon"
  #     cat "#{path}/.katon"
  #   else if test '-e', "#{path}/package.json"
  #     pkg = JSON.parse(fs.readFileSync "#{path}/package.json")
  #     start = pkg.scripts?.start
  #     main = pkg.main
  #     if main?
  #       @nodemonPath
  #       # start.replace 'node', @nodemonPath
  #     else
  #       start.split(' ')[0]
  #   else 
  #     @staticPath

  # getOptions: (path, port) ->
  #   if test '-e', "#{path}/.katon"
  #     cat "#{path}/.katon"
  #   else if test '-e', "#{path}/package.json"
  #     pkg = JSON.parse(fs.readFileSync "#{path}/package.json")
  #     start = pkg.scripts?.start
  #     main = pkg.main
  #     if main?
  #       []
  #     else
  #       [start.split(' ')[1]]
  #   else 
  #     "#{path} --port #{port}".split(' ')

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