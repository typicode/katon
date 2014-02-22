fs = require 'fs'
p = require 'path'
chalk = require 'chalk'
minimatch = require 'minimatch'
clone = require 'clone'
config = require '../config'

module.exports =

  log: (str) ->
    console.log chalk.cyan('app  '), str

  error: (path, str) ->
    console.log chalk.red("app   #{path?.split('/').pop()}"), str

  append: (path, data) ->
    fs.appendFileSync path, data

  findDir: (path, pattern) ->
    for v in fs.readdirSync(path).reverse()
      return v if minimatch v, pattern

  getNodePath: (path) ->
    nvmrcPath = "#{path}/.nvmrc"
    if fs.existsSync nvmrcPath
      version = fs.readFileSync(nvmrcPath).toString().trim()
      versionDir = @findDir config.nvmPath, "v#{version}*"
      return "#{config.nvmPath}/#{versionDir}/bin"

    "/usr/local/bin:#{p.dirname(process.execPath)}"

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