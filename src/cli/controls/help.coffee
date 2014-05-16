fs     = require 'fs'
chalk  = require 'chalk'
common = require '../common'

module.exports =

  usage: ->
    path = "#{__dirname}/../../../doc/help.txt"
    str  = fs
      .readFileSync(path, 'utf8')
      .replace(/katon/g, chalk.cyan.bold 'katon')

    console.log str

  version: ->
    pkg = require '../../../package.json'
    console.log pkg.version

  status: ->
    output = common.execSync 'launchctl list | grep \'katon\''

    katonLoaded = output.indexOf('katon') isnt -1

    if not katonLoaded 
      console.log()
      console.log "#{chalk.red 'katon'} is not loaded, use `katon start`"
  