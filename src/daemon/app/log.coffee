fs    = require 'fs'
p     = require 'path'
chalk = require 'chalk'

append = (path, msg) ->
  fs.appendFile "#{path}/katon.log", "#{msg}", (err) ->
    loggers.daemon.error path, err if err

loggers =

  app:
    log: (path, msg) ->
      append path, "#{chalk.cyan '[katon]'} #{msg}\n"

    error: (path, msg) ->
      append path, "#{chalk.red '[katon]'} #{msg}\n"

    plain: (path, msg) ->
      append path, msg

  daemon:
    log: (path, msg) ->
      console.log "#{chalk.cyan '[app]'}   #{p.basename path} #{msg}"

    error: (path, msg) ->
      console.log "#{chalk.red '[app]'}   #{p.basename path} #{msg}"

  global:
    log: (path, msg) =>
      loggers.app.log path, msg
      loggers.daemon.log path, msg

    error: (path, msg) => 
      loggers.app.error path, msg
      loggers.daemon.error path, msg

module.exports = loggers



    

