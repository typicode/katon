assert = require 'assert'
sinon = require 'sinon'
proxy = require '../../../src/daemon/proxy'

describe 'proxy', ->

  beforeEach ->
    proxy.paths = []

  describe 'add(path)', ->

    beforeEach ->
      proxy.reload = sinon.spy()
      @port = proxy.add '/some/path/foo'

    it 'adds path, returns port and reloads proxy', ->
      assert.equal proxy.paths.length, 1
      assert.equal @port, 4001
      assert proxy.reload.calledWith 'foo.dev': '127.0.0.1:4001'
      assert proxy.reload.called

  describe 'remove(path)', ->

    beforeEach ->
      proxy.add '/some/path/foo'
      proxy.reload = sinon.spy()
      proxy.remove '/some/path/foo'

    it 'nullifies path and reloads proxy', ->
      assert.equal proxy.paths.length, 1
      assert.equal proxy.paths[0], null
      assert proxy.reload.calledWith {}
      assert.equal proxy.reload.callCount, 1