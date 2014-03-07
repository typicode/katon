assert = require 'assert'
config = require '../test_config'
link = require '../../../src/cli/commands/link'

setUp = ->
  # Clear
  rm '-rf', '/tmp/my_app', config.katonPath, config.powPath
  # Create directories but not .katon to assert it will be created
  mkdir '/tmp/my_app', config.powPath

describe 'link(path)', ->

  beforeEach ->
    setUp()
    link '/tmp/my_app'

  it 'should create .katon directory', ->
    assert test '-e', config.katonPath

  it 'should create a proxy file in .pow', ->
    assert.equal cat("#{config.powPath}/my-app"), 4000

  it 'should create a symlink in .katon directory', ->
    assert test '-L', "#{config.katonPath}/my-app"

describe 'link(path, execString)', ->

  beforeEach ->
    setUp()
    link '/tmp/my_app', 'foo'

  it 'should create .katon directory', ->
    assert test '-e', config.katonPath

  it 'should create a proxy file in .pow', ->
    assert.equal cat("#{config.powPath}/my-app"), 4000

  it 'should create a symlink in .katon directory', ->
    assert test '-L', "#{config.katonPath}/my-app"

  it 'should create a .katon in app directory', ->
    assert.equal cat('/tmp/my_app/.katon'), 'foo'