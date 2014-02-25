fs = require 'fs'
chalk = require 'chalk'
config = require '../config'
env = require './env'

module.exports =

  get: (path, port) ->
    katonPath = "#{path}/.katon"
    packagePath = "#{path}/package.json"

    command = 'static --port $PORT'

    if fs.existsSync katonPath
      command = fs.readFileSync(katonPath).toString()

    if fs.existsSync packagePath
      pkg = JSON.parse(fs.readFileSync packagePath)

      if pkg.main?
        command = 'nodemon' # nodemon will start by default package.main

      else if pkg.scripts?.start?
        command = pkg.scripts.start.replace 'node', 'nodemon'

    command
      .replace('nodemon', config.nodemonPath)
      .replace('static', config.staticPath)
      .replace(/\$PORT/g, port)
      .split ' '
