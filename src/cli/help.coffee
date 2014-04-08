fs     = require 'fs'
chalk  = require 'chalk'
common = require './common'

module.exports =

  usage: ->
    path = "#{__dirname}/../../doc/help.txt"
    str  = fs
      .readFileSync(path, 'utf8')
      .replace(/katon/g, chalk.red 'katon')

    console.log str

  version: ->
    pkg = require '../../package.json'
    console.info pkg.version

  status: ->
    output = common.sh 'launchctl list | grep \'katon\\|pow\''

    katonLoaded = output.indexOf('katon') isnt -1
    powLoaded   = output.indexOf('pow') isnt -1

    if not katonLoaded or not powLoaded
      console.log()

    if not katonLoaded 
      console.log "#{chalk.red 'katon'} is not loaded, use `katon start`"
    
    if not powLoaded
      console.log "#{chalk.red 'pow'}   is not loaded/installed?"