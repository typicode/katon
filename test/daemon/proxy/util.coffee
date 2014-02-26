assert = require 'assert'
util = require '../../../src/daemon/proxy/util'

describe 'proxy/util', ->

  describe 'getHost(path)', ->

    it 'returns host from path', ->
      assert.equal util.getHost('/some/path/foo'), 'foo.dev'

  describe 'getRouter(paths)', ->

    it 'returns router map', ->
      actual = util.getRouter [
        '/some/path/foo',
        null,
        '/some/path/baz'
      ]
      expected =
        'foo.dev': '127.0.0.1:4001'
        'baz.dev': '127.0.0.1:4003'
      assert.deepEqual actual, expected

  describe 'getPorts(paths)', ->

    it 'returns ports map', ->
      actual = util.getPorts [
        '/some/path/foo',
        null,
        '/some/path/baz'
      ]
      expected =
        '/some/path/foo': 4001
        '/some/path/baz': 4003

      assert.deepEqual actual, expected