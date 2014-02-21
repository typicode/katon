require 'shelljs/global'
fs = require 'fs'

module.exports =

  nodemon: "#{__dirname}/../../node_modules/.bin/nodemon"

  static: "#{__dirname}/../../node_modules/.bin/static"

  getCommand: (path, port) ->
    command = "#{@static} --port $PORT"

    if test '-e', "#{path}/.katon"
      command = cat "#{path}/.katon"

    else if test '-e', "#{path}/package.json"
      pkg = JSON.parse(fs.readFileSync "#{path}/package.json")
      if pkg.main?
        command = @nodemon
      else if pkg.scripts?.start?
        command = pkg.scripts.start.replace 'node', @nodemon

    command = "PORT=$PORT #{command}"
    command.replace /\$PORT/g, port

  getLogPath: (path) ->
    logPath = "#{path}/katon.log"
    if test '-e', "#{path}/.katon_log"
      logPath = cat "#{path}/.katon_log"
      logPath = "#{path}/#{logPath}"

    logPath