assert = require 'assert'
config = require '../test_config'
unlink = require '../../../src/cli/commands/unlink'

setUp = ->
  # Create proxy
  ''.to "#{config.powPath}/app"
  # Create symlink
  exec "ln -s /tmp/app #{config.katonPath}/app"

describe 'unlink(path)', ->

  beforeEach ->
    setUp()
    unlink '/tmp/app'

  it 'should remove the proxy file in .pow', ->
    assert !test '-f', "#{config.powPath}/app"

  it 'should remove the symlink in .katon', ->
    assert !test '-L', "#{config.katonPath}/app"

describe 'unlink(appName)', ->

  beforeEach ->
    setUp()
    unlink 'app'

  it 'should remove the proxy file in .pow', ->
    assert !test '-f', "#{config.powPath}/app"

  it 'should remove the symlink in .katon', ->
    assert !test '-L', "#{config.katonPath}/app"