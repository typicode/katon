daemon   = require './controls/daemon'
link     = require './controls/link'
exec     = require './controls/exec'
help     = require './controls/help'

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
    daemon.create()
    daemon.load()

  stop: ->
    daemon.unload()
    daemon.remove()

  status: ->
    help.status()

  run: ([action, option]) ->
    if @[action]
      @[action] option
    else
      @['help']()
