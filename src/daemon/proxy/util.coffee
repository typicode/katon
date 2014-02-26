fs = require 'fs'
chalk = require 'chalk'

module.exports =

  log: (str) ->
    console.log chalk.yellow('proxy'), str

  getHost: (path) ->
    "#{path.split('/').pop()}.dev"

  getPorts: (paths) ->
    ports = {}
    for path, index in paths
      if path?
        ports[path] = 4001+index
    ports

  getRouter: (paths) ->
    router = {}
    for path, port of @getPorts(paths)
      host = @getHost path
      target = "127.0.0.1:#{port}"
      router[host] = target
    router