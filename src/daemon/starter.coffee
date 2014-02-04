require 'shelljs/global'
fs = require 'fs'
chalk = require 'chalk'
commander = require './commander'

module.exports.start = (appPath, port) ->
  # Get command
  command = commander.getCommand appPath, port
  
  # Change directory
  cd appPath
  
  # Log command to /var/log/system.log and <app_directory>/katon.log
  console.log chalk.underline.bold.cyan(appPath, command)
  # chalk.underline.bold.cyan(command).toEnd "#{appPath}/katon.log"

  # Spawn process
  child = exec command, async: true

  # Log on exit and restart process
  child.on 'exit', =>
    restart = => @start appPath, port
    restartMessage =
      chalk.underline.bold.red "Restarting #{appPath} in 10 seconds"
    
    # Log to /var/log/system.log and <app_directory>/katon.log
    console.log restartMessage
    restartMessage.toEnd "#{appPath}/katon.log"

    setTimeout restart, 10000

  # Log process output to <app_directory>/katon.log
  child.stdout.on 'data', (data) -> data.toEnd "#{appPath}/katon.log"
  child.stderr.on 'data', (data) -> data.toEnd "#{appPath}/katon.log"

  ->
    console.log("kill")
    child.removeAllListeners 'exit'
    child.kill()