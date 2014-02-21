require 'shelljs/global'
fs = require 'fs'
chalk = require 'chalk'
log = require './log'
commander = require './commander'

module.exports.spawn = (appPath, command, logPath) ->
  # Change directory
  cd appPath
  
  # Log command to /var/log/system.log and <app_directory>/katon.log
  log "#{appPath}"
  log "  #{command}"
  
  chalk.underline.bold.cyan(command).toEnd "#{logPath}/katon.log"

  # Spawn process
  child = exec command, async: true

  # Log on exit and restart process
  child.on 'exit', =>
    restart = => @spawn appPath, command
    restartMessage =
      chalk.underline.bold.red "Restarting #{appPath} in 10 seconds"
    
    # Log to /var/log/system.log and <app_directory>/katon.log
    log restartMessage
    restartMessage.toEnd "#{logPath}/katon.log"

    setTimeout restart, 10000

  # Log process output to <app_directory>/katon.log
  child.stdout.on 'data', (data) -> data.toEnd "#{logPath}/katon.log"
  child.stderr.on 'data', (data) -> data.toEnd "#{logPath}/katon.log"

  child