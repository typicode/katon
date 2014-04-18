assert = require 'assert'
config = require '../../../src/config'
env    = require '../../../src/daemon/apps/env'

assertEnv = (path, expectedPATH) ->
  it "#{path} returns process env", ->
    path = "#{__dirname}/fixtures/#{path}"

    processEnv = env.get path, 4001

    assert.notEqual processEnv, process.env, 'should be a clone of process.env'
    assert.equal processEnv.PORT, 4001
    assert.equal processEnv.PATH.indexOf(expectedPATH), 0,
      "#{processEnv.PATH} should start with #{expectedPATH}"

describe 'app/env', ->

  describe 'get(path, port)', ->

    describe 'nvm', ->

      beforeEach -> config.nvmDir = "#{__dirname}/fixtures/nvm/.nvm"

      assertEnv 'nvm/nvmrc', "#{__dirname}/fixtures/nvm/.nvm/v0.10.26/bin"
      assertEnv 'nvm/default', "#{__dirname}/fixtures/nvm/.nvm/v0.11.11/bin"

    describe 'node', ->

      beforeEach -> config.nvmDir = "#{__dirname}/fixtures/node/.nvm"

      assertEnv 'node/package_main', "/usr/local/bin"

    describe 'static', ->

      beforeEach -> config.nvmDir = "#{__dirname}/fixtures/static/.nvm"

      assertEnv 'static', "/usr/local/bin"