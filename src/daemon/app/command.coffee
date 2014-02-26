fs = require 'fs'
config = require '../config'
env = require './env'
util = require './util'

module.exports =

  get: (path, port) ->
    katonPath = "#{path}/.katon"
    packagePath = "#{path}/package.json"

    command = 'static --port $PORT'

    if fs.existsSync katonPath
      command = fs.readFileSync(katonPath).toString()

    if fs.existsSync packagePath
      try
        pkg = JSON.parse(fs.readFileSync packagePath)

        if pkg.main?
          command = 'nodemon' # nodemon will start by default package.main

        else if pkg.scripts?.start?
          command = pkg.scripts.start.replace 'node', 'nodemon'
      catch e
        msg = "package.json: #{e}"
        util.error path, msg
        util.append "#{path}/katon.log", msg

    command
      .replace('nodemon', config.nodemonPath)
      .replace('static', config.staticPath)
      .replace(/\$PORT/g, port)
      .split ' '
