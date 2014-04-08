fs    = require 'fs.extra'
chalk = require 'chalk'
proxy = require './proxy/'
apps  = require './apps/'

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
      apps.add "#{config.katonDir}/#{name}"

  watch: ->
    fs.watch config.katonDir, (event, filename) ->
      if fs.existsSync "#{config.katonDir}/#{filename}"
        apps.add filename
      else
        apps.remove filename