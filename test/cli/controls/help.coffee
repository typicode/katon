sinon = require 'sinon'
help  = require '../../../src/cli/controls/help'

describe 'help', ->

  beforeEach ->
    sinon.stub console, 'log'

  afterEach ->
    console.log.restore()

  # Just checking it doesn't crash
  it 'usage', -> help.usage()
  it 'version', -> help.version()
