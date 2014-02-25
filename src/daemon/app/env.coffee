fs = require 'fs'
p = require 'path'
minimatch = require 'minimatch'
clone = require 'clone'
config = require '../config'

module.exports =

  readFile: (path) ->
    fs.readFileSync(path).toString().trim()

  findDir: (path, pattern) ->
    if fs.existsSync path
      for v in fs.readdirSync(path).reverse()
        return v if minimatch v, pattern

  findVersionDir: (version) ->
    versionDir = @findDir config.nvmPath, "v#{version}*"
    if versionDir
      "#{config.nvmPath}/#{versionDir}/bin"

  getNodePath: (path) ->
    nvmrcPath = "#{path}/.nvmrc"
    defaultPath = "#{config.nvmPath}/alias/default"

    if fs.existsSync nvmrcPath
      version = @readFile nvmrcPath
      return @findVersionDir version

    if fs.existsSync defaultPath
      version = @readFile defaultPath
      return @findVersionDir version

    "/usr/local/bin:#{p.dirname(process.execPath)}"

  get: (path, port) ->
    processEnv = clone process.env

    processEnv.PORT = port

    nodePath = @getNodePath path
    console.log nodePath
    processEnv.PATH = "#{nodePath}:#{processEnv.PATH}"

    processEnv