katon = require './katon'

module.exports = 
  
  katon: katon
  
  run: (argv) ->
    argv = require('optimist').parse argv

    if 'help' in argv._
      @katon.help()

    if 'link' in argv._
      @katon.link process.cwd()
      if argv.exec then @katon.exec(argv.exec)
    
    if 'unlink' in argv._
      if argv.name
        @katon.unlink argv.name
      else
        @katon.unlink process.cwd()

    if 'list' in argv._
      @katon.list()

    if 'start' in argv._
      @katon.start()

    if 'stop' in argv._
      @katon.stop()

    if 'status' in argv._
      @katon.status()


