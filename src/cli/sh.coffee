shell = require 'shelljs'
chalk = require 'chalk'

module.exports = (cmd) ->
  console.log chalk.grey cmd
  shell.exec cmd
