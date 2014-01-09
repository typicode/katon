katon = require './katon'

module.exports = 
  
  katon: katon

  usage: """

    Usage: katon <command> [options]

    Commands:
      link                 Link current directory
      link --exec <cmd>    Use custom cmd to start server
         
      unlink               Unlink current directory
      unlink --name <app>  Unlink app
   
      list                 List linked apps
         
      start                Start Katon daemon
      stop                 Stop Katon daemon
         
      install-pow          Install Pow
         
      status               Katon status information

    Examples:
      katon install
      katon link
      katon link --exec \'grunt server watch\'
      katon link --exec \'python -m SimpleHTTPServer -p %PORT%\'
  """
  
  run: (argv) ->
    argv = require('optimist').parse argv

    if 'link' in argv._
      @katon.link()
      if argv.exec then @katon.exec(argv.exec)
    
    if 'unlink' in argv._
      @katon.unlink(argv.name)

    if 'list' in argv._
      @katon.list()

    if 'start' in argv._
      @katon.start()

    if 'stop' in argv._
      @katon.stop()

    if 'status' in argv._
      @katon.status()

    
