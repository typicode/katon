assert = require 'assert'
config = require '../test_config'
unlink = require '../../../src/cli/commands/unlink'

setUp = ->
  # Create proxy
  ''.to "#{config.powPath}/my-app"
  # Create symlink
  exec "ln -s /tmp/my_app #{config.katonPath}/my-app"

describe 'unlink(path)', ->

  beforeEach ->
    setUp()
    unlink '/tmp/my_app'

  it 'should remove the proxy file in .pow', ->
    assert !test '-f', "#{config.powPath}/my-app"

  it 'should remove the symlink in .katon', ->
    assert !test '-L', "#{config.katonPath}/my-app"

describe 'unlink(appName)', ->

  beforeEach ->
    setUp()
    unlink 'my_app'

  it 'should remove the proxy file in .pow', ->
    assert !test '-f', "#{config.powPath}/my-app"

  it 'should remove the symlink in .katon', ->
    assert !test '-L', "#{config.katonPath}/my-app"