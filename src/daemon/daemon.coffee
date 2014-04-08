fs    = require 'fs.extra'
chalk = require 'chalk'
proxy = require './proxy/'
app  = require './app/'

config = require '../config'

module.exports =

  init: ->
    console.log """

      #{chalk.underline 'Katon Initialize daemon'}

    """

    # make sure ~/.katon exists
    fs.mkdirp config.katonDir
    
    # start server
    proxy.start()

    for name in fs.readdirSync config.katonDir
      app.add "#{config.katonDir}/#{name}"

  watch: ->
    fs.watch config.katonDir, (event, name) ->
      path = "#{config.katonDir}/#{name}"
      if fs.existsSync path
        app.add path
      else
        app.remove path