chalk    = require 'chalk'
daemon   = require './controls/daemon'
resolver = require './controls/resolver'
firewall = require './controls/firewall'
link     = require './controls/link'
exec     = require './controls/exec'
help     = require './controls/help'
common   = require './common'
config   = require '../config'
render   = require '../render'

chalk.enabled = true

module.exports =

  '-v': ->
    help.version()
  
  '--version' : ->
    help.version()

  help: -> 
    help.usage()

  link: (cmd) ->
    exec.create process.cwd(), cmd if cmd
    link.create process.cwd()

  unlink: (path = process.cwd()) ->
    exec.remove path
    link.remove path

  list: ->
    link.list()

  open: (path = process.cwd()) ->
    link.open path

  start: ->
    console.log chalk.green 'Starting katon daemon'
    daemon.create()
    daemon.load()

  stop: ->
    console.log chalk.red 'Stopping katon daemon'
    daemon.unload()
    daemon.remove()

  status: ->
    help.status()

  install: ->
    console.log chalk.green 'Installing katon'
    common.exec render 'shell/install.sh.eco', config

  uninstall: ->
    console.log chalk.red 'Uninstalling katon'
    common.exec render 'shell/uninstall.sh.eco', config

  # Called only by (un)install.sh scripts using sudo
  __install: ->
    console.log chalk.green 'System'
    resolver.create()
    firewall.create()
    firewall.load()

  __uninstall: ->
    console.log chalk.red 'System'
    resolver.remove()
    firewall.unload()
    firewall.remove()
    firewall.deleteRule()

  run: ([action, option]) ->
    if @[action]
      @[action] option
    else
      @['help']()
