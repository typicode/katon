assert = require 'assert'
sinon = require 'sinon'
_ = require 'lodash'
manager = require '../../src/daemon/app_manager'

describe 'appManager', ->

  describe 'getPort()', ->

    describe 'when app list is empty', ->

      beforeEach ->
        manager.apps = []

      it 'returns 4001', ->
        assert.equal manager.getPort(), 4001

    describe 'when app list is not empty', ->

      beforeEach ->
        manager.apps = [port: 4002]

      it 'returns an available port', ->
        assert.equal manager.getPort(), 4003


  describe 'getProxyTable()', ->

    beforeEach ->
      manager.apps = [
        {host: 'foo.dev', port: 4001}
        {host: 'bar.dev', port: 4002}
      ]

    it 'returns a proxy table', ->
      assert.deepEqual manager.getProxyTable(),
        'foo.dev': '127.0.0.1:4001'
        'bar.dev': '127.0.0.1:4002'

  describe 'create(name)', ->

    beforeEach ->
      manager.apps = []
      manager.katonPath = '/tmp/.katonPath'

      sinon.stub(manager.commander, 'getCommand').returns 'command'
      sinon.stub(manager.spawner, 'spawn').returns 'process'
      
      @app = manager.create 'foo'

    afterEach ->
      manager.commander.getCommand.restore()
      manager.spawner.spawn.restore()

    it 'creates a new app in app list', ->
      assert.equal manager.apps.length, 1

    it 'calls commander.getCommand', ->
      assert manager.commander.getCommand.calledWith '/tmp/.katonPath/foo', 4001

    it 'calls spawner.spawn', ->
      assert manager.spawner.spawn.calledWith '/tmp/.katonPath/foo', 'command'

    it 'sets app properties', ->
      assert.equal @app.name, 'foo'
      assert.equal @app.port, 4001
      assert.equal @app.host, 'foo.dev'
      assert.equal @app.process, 'process'
      assert @app.stop instanceof Function

  describe 'remove(name)', ->

    beforeEach ->
      @app =
        name: 'foo'
        stop: sinon.spy()
      manager.apps = [@app]
      manager.remove 'foo'

    it 'removes app', ->
      assert.equal manager.apps.length, 0

    it 'stops process', ->
      assert @app.stop.called