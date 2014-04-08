p      = require 'path'
fs     = require 'fs.extra'
chalk  = require 'chalk'
eco    = require 'eco'
sh     = require './sh'
config = require '../config'

module.exports =

  tilde: (path) ->
    path.replace process.env.HOME, '~'

  create: (path, content, options) ->
    console.log "#{chalk.cyan 'create'} #{@tilde path}"

    # create path if it doesn't exist
    fs.mkdirp p.dirname path

    # write file
    fs.writeFileSync path, content, options

  remove: (path) ->
    if fs.existsSync path
      console.log "#{chalk.red 'remove'} #{@tilde path}"
      fs.unlinkSync path

  load: (path) ->
    sh "launchctl load -Fw #{path}"

  unload: (path) ->
    sh "launchctl unload #{path}"

  render: (file) ->
    tpl = fs.readFileSync "#{__dirname}/../../templates/#{file}", 'utf-8'
    eco.render tpl, config