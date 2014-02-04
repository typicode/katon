assert = require 'assert'
config = require '../test_config'
link = require '../../../src/cli/commands/link'

setUp = ->
  # Clear
  rm '-rf', '/tmp/app', config.katonPath, config.powPath
  # Create directories but not .katon to assert it will be created
  mkdir '/tmp/app', config.powPath

describe 'link(path)', ->

  beforeEach ->
    setUp()
    link '/tmp/app'

  it 'should create .katon directory', ->
    assert test '-e', config.katonPath

  it 'should create a proxy file in .pow', ->
    assert.equal cat("#{config.powPath}/app"), 4000

  it 'should create a symlink in .katon directory', ->
    assert test '-L', "#{config.katonPath}/app"

describe 'link(path, execString)', ->

  beforeEach ->
    setUp()
    link '/tmp/app', 'foo'

  it 'should create .katon directory', ->
    assert test '-e', config.katonPath

  it 'should create a proxy file in .pow', ->
    assert.equal cat("#{config.powPath}/app"), 4000

  it 'should create a symlink in .katon directory', ->
    assert test '-L', "#{config.katonPath}/app"

  it 'should create a .katon in app directory', ->
    assert.equal cat('/tmp/app/.katon'), 'foo'