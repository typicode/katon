fs        = require 'fs'
p         = require 'path'
minimatch = require 'minimatch'
clone     = require 'clone'
log       = require './log'
config    = require '../../config'

module.exports =

  read: (path) ->
    fs.readFileSync(path)
      .toString()
      .trim()

  find: (path, version) ->
    try
      log.log path, "Looking for #{version}"
      for dir in fs.readdirSync(config.nvmDir).reverse()
        if minimatch dir, "v#{version}*"
          PATH = "#{config.nvmDir}/#{dir}/bin"
          log.global.log path, "Using #{PATH}"
          return PATH
    catch
      log.error path, "Can't find #{version} in #{config.nvmDir}"

  nvmrc: (path) ->
    try
      version = @read "#{path}/.nvmrc"
      log.global.log path, "Detected .nvmrc"
      @find path, version
    catch

  nvmDefault: (path) ->
    try
      version = @read "#{config.nvmDir}/alias/default"
      common.log path, "Detected ~/.nvm/alias/default"
      @find path, version
    catch

  node: ->
    nodePath = p.dirname(process.execPath)
    "/usr/local/bin:#{nodePath}"

  getPATH: (path) ->
    PATH = @nvmrc path
    PATH or= @nvmDefault path
    PATH or= @node()
    PATH

  get: (path, port) ->
    processEnv = clone process.env
    processEnv.PORT = port
    processEnv.PATH = "#{@getPATH(path)}:#{processEnv.PATH}"
    processEnv