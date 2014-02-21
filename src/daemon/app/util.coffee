fs = require 'fs'
clone = require 'clone'
config = require '../config'

module.exports =

  log: (path, data) ->
    fs.appendFileSync "#{path}/katon.log", data

  getNodePath: (path) ->
    nvmrcPath = "#{path}/.nvmrc"

    if fs.existsSync nvmrcPath
      version = fs.readFileSync nvmrcPath
      return "#{process.env.HOME}/.nvm/v#{version}/bin"

    '/usr/local/bin'

  getCommandLine: (path) ->
    katonPath = "#{path}/.katon"
    packagePath = "#{path}/package.json"

    if fs.existsSync katonPath
      return fs.readFileSync(katonPath).toString()

    if fs.existsSync packagePath
      pkg = JSON.parse(fs.readFileSync packagePath)

      if pkg.main?
        return 'nodemon' # nodemon will start by default package.main

      else if pkg.scripts?.start?
        return pkg.scripts.start.replace 'node', 'nodemon'

    'static --port $PORT'

  getCommand: (commandLine) ->
    commandLine.split(' ')[0]

  getArgs: (commandLine) ->
    args = commandLine.split ' '
    args.shift()
    args

  replacePort: (str, port) ->
    str.replace /\$PORT/g, port

  getSpawnArgs: (path, port) ->
    env = clone process.env
    env.PORT = port

    nodePath = @getNodePath path
    env.PATH = "#{nodePath}:#{env.PATH}"

    commandLine = @getCommandLine path
    commandLine = @replacePort commandLine, port

    command = @getCommand commandLine
    command = command.replace 'static', config.staticPath
    command = command.replace 'nodemon', config.nodemonPath

    args = @getArgs commandLine
    
    cwd = path
    
    [command, args, cwd: path, env: env]

  getRespawnArgs: (path, port) ->
    env = clone process.env
    env.PORT = port

    nodePath = @getNodePath path
    env.PATH = "#{nodePath}:#{env.PATH}"

    commandLine = @getCommandLine path
    commandLine = @replacePort commandLine, port
    commandLine = commandLine.replace 'static', config.staticPath
    commandLine = commandLine.replace 'nodemon', config.nodemonPath
    
    cwd = path
    
    command: commandLine.split ' '
    cwd: path
    env: env