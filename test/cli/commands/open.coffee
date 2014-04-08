# assert = require 'assert'
# config = require '../test_config'
# emitter = require '../../../src/cli/util/emitter'
# link = require '../../../src/cli/commands/link'
# open = require '../../../src/cli/commands/open'
#
# setUp = ->
#   # Clear
#   rm '-rf', '/tmp/my_app', config.katonPath, config.powPath
#   # Create directories but not .katon to assert it will be created
#   mkdir '/tmp/my_app', config.powPath
#
# describe 'open()', ->
#
#   beforeEach ->
#     setUp()
#     link '/tmp/my_app'
#
#   it 'should open a browser', ->
#     open('my_app')
