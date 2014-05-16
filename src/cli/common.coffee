childExtra = require 'child_process'
p          = require 'path'
fs         = require 'fs.extra'
shell      = require 'shelljs'
chalk      = require 'chalk'
tildify    = require 'tildify'
eco        = require 'eco'
config     = require '../config'

module.exports =

  execSync: (cmd) ->
    console.log chalk.grey tildify cmd
    output = shell.exec(cmd, silent: true).output.trim()

    unless output is ''
      console.log chalk.grey output
    
    output

  exec: (cmd) ->
    childExtra.exec cmd, (err, stdout, stderr) ->
      console.info stdout
      console.error stderr
      if err
        console.error err

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
    @sh "launchctl load -Fw #{path}"

  unload: (path) ->
    @sh "launchctl unload #{path}"

