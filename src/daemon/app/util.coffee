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

  getRespawnArgs: (path, port) ->
    env = clone process.env
    env.PORT = port

    nodePath = @getNodePath path
    env.PATH = "#{nodePath}:#{env.PATH}"

    commandLine = @getCommandLine(path)
      .replace(/\$PORT/g, port)
      .replace('nodemon', config.nodemonPath)
      .replace('static', config.staticPath)

    cwd = path
    
    command: commandLine.split ' '
    cwd: path
    env: env