program = require 'commander'
katon = require './katon'

program.option 'link', 'link the current dir'

module.exports = 
  
  katon: katon
  
  run: (argv) ->
    program.parse argv
    if program.link then @katon.link()