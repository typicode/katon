p      = require 'path'
fs     = require 'fs.extra'
shell  = require 'shelljs'
chalk  = require 'chalk'
eco    = require 'eco'
config = require '../config'

module.exports =

  # output beautification
  tilde: (path) ->
    path.replace process.env.HOME, '~'

  # file create and remove
  create: (path, content, options) ->
    console.log chalk.grey "create #{@tilde path}"

    # create path if it doesn't exist
    fs.mkdirp p.dirname path

    # write file
    fs.writeFileSync path, content, options

  remove: (path) ->
    if fs.existsSync path
      console.log chalk.grey "remove #{@tilde path}"
      fs.unlinkSync path 

  # plist load and unload
  sh: (cmd) ->
    console.log chalk.grey @tilde cmd
    output = shell.exec(cmd, silent: true).output.trim()

    unless output is ''
      console.log chalk.grey output
    
    output

  load: (path) ->
    @sh "launchctl load -Fw #{path}"

  unload: (path) ->
    @sh "launchctl unload #{path}"

  # template rendering
  render: (file) ->
    tpl = fs.readFileSync "#{__dirname}/../../templates/#{file}", 'utf-8'
    eco.render tpl, config