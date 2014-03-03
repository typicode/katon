assert = require 'assert'
config = require '../test_config'
emitter = require '../../../src/cli/util/emitter'
start = require '../../../src/cli/commands/start'
fs = require 'fs'

describe 'start()', ->

  beforeEach ->
    rm '-rf', config.launchAgentsPath
    mkdir config.launchAgentsPath
    # Test on Linux workaround
    emitter.on 'error', (message) -> console.error message
    start()

  it 'should put a katon.plist in config.launchAgentsPath', ->
    assert test '-e', "#{config.launchAgentsPath}/katon.plist"
  
  it 'should set the correct permissions on the katon.plist file'
    # pending test