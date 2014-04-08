assert   = require 'assert'
sinon    = require 'sinon'
App      = require '../../../src/daemon/app/'
monitor  = require '../../../src/daemon/app/monitor'

describe 'app', ->

  describe 'create(path, port)', ->

    beforeEach ->
      sinon.spy monitor, 'create'

    afterEach ->
      monitor.create.restore()

    it 'starts app and returns an object', ->
      app = App.create '/some/app', 4001

      assert app.path, '/some/app'
      assert app.port, 4001
      assert app.name, 'app'
      assert monitor.create.calledWith '/some/app', 4001