katon = require './katon'

module.exports = 
  
  katon: katon
  
  run: (argv) ->
    commander = require 'commander'

    commander
      .version('0.0.1')
      .option('link', 'link the current dir')
      .option('-e --exec <cmd>', 'add a .katon exec file')
      .option('unlink', 'unlink the current dir')
      .option('load', 'load katon daemon')
      .option('unload', 'unload katon daemon')
      .option('list', 'list linked apps')
      .option('install-pow', 'install or update pow')
      .option('status', '')
      .parse(process.argv)

    console.log argv
    commander.parse argv
    console.log commander
    if commander.link then @katon.link()
    if commander.exec then @katon.exec commander.exec