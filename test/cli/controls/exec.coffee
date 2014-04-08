fs     = require 'fs.extra'
sinon  = require 'sinon'
config = require '../../../src/config'
common = require '../../../src/cli/common'
exec   = require '../../../src/cli/controls/exec'

describe 'exec', ->

  describe 'create(path, cmd)', ->

    beforeEach ->
      common.create = sinon.spy()

    it 'should create .katon', ->
      exec.create '/some/app', 'foo bar'
      sinon.assert.calledWith common.create, '/some/app/.katon', 'foo bar'

  describe 'remove(path, cmd)', ->

    beforeEach ->
      common.remove = sinon.spy()

    it 'should remove .katon', ->
      exec.remove '/some/app'
      sinon.assert.calledWith common.remove, '/some/app/.katon'