fs    = require 'fs'
chalk = require 'chalk'
sh    = require './sh'

module.exports =

  usage: ->
    path = "#{__dirname}/../../doc/help.txt"
    str  = fs
      .readFileSync(path, 'utf8')
      .replace(/katon/g, chalk.green 'katon')

    console.log str

  version: ->
    pkg = require '../../package.json'
    console.info pkg.version

  status: ->
    sh 'launchctl list | grep \'katon\\|pow\''