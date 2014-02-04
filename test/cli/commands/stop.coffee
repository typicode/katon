assert = require 'assert'
config = require '../test_config'
emitter = require '../../../src/cli/util/emitter'
stop = require '../../../src/cli/commands/stop'

describe 'stop()', ->

  beforeEach ->
    # Create plist
    ''.to "#{config.launchAgentsPath}/katon.plist"
    # Test on Linux workaround
    emitter.on 'error', (message) -> console.error message
    stop()

  it 'should remove the katon.plist in katon.launchAgentsPath', ->
    assert !test '-e', "#{config.launchAgentsPath}/katon.plist"