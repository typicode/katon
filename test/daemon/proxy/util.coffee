assert = require 'assert'
util = require '../../../src/daemon/proxy/util'

describe 'proxy/util', ->

  describe 'getDomain(host)', ->

    it 'returns domain from host', ->
      assert.equal util.getDomain('example.com'), 'example'
      assert.equal util.getDomain('www.example.com'), 'example'