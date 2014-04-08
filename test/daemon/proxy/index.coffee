assert = require 'assert'
index = require '../../../src/daemon/proxy/index'

describe 'proxy/index', ->

  describe 'getDomain(host)', ->

    it 'returns domain from host', ->
      assert.equal index.getDomain('example.com'), 'example'
      assert.equal index.getDomain('www.example.com'), 'example'