childProcess = require 'child_process'
p          = require 'path'
fs         = require 'fs.extra'
shell      = require 'shelljs'
chalk      = require 'chalk'
tildify    = require 'tildify'
eco        = require 'eco'
config     = require '../config'

module.exports =

  exec: (cmd) ->
    childProcess.exec cmd, (err, stdout, stderr) ->
      console.log stdout if stdout isnt ''
      console.error stderr if stderr isnt ''
      if err
        console.error err

  execSync: (cmd) ->
    console.log chalk.grey tildify cmd
    output = shell.exec(cmd, silent: true).output.trim()

    unless output is ''
      console.log chalk.grey output
    
    output

  create: (path, content, options) ->
    console.log chalk.grey "create #{tildify path}"

    # create path if it doesn't exist
    fs.mkdirp p.dirname path

    # write file
    fs.writeFileSync path, content, options

  remove: (path) ->
    try
      fs.unlinkSync path
      # cheating a little
      console.log chalk.grey "remove #{tildify path}"

  load: (path) ->
    @execSync "launchctl load -Fw #{path}"

  unload: (path) ->
    @execSync "launchctl unload #{path}"

