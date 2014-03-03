fs = require 'fs'
p = require 'path'
minimatch = require 'minimatch'
clone = require 'clone'
util = require './util'
config = require '../config'

module.exports =

  read: (path) ->
    fs.readFileSync(path)
      .toString()
      .trim()

  find: (path, version) ->
    try
      util.log path, "Looking for #{version}"
      for dir in fs.readdirSync(config.nvmPath).reverse()
        if minimatch dir, "v#{version}*"
          PATH = "#{config.nvmPath}/#{dir}/bin"
          util.log path, "Using #{PATH}"
          return PATH
    catch

  nvmrc: (path) ->
    try
      version = @read "#{path}/.nvmrc"
      util.log path, "Detected .nvmrc"
      @find path, version
    catch

  nvmDefault: (path) ->
    try
      version = @read "#{config.nvmPath}/alias/default"
      util.log path, "Detected .nvm/alias/default"
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