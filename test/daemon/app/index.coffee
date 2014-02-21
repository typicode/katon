assert = require 'assert'
sinon = require 'sinon'
app = require '../../../src/daemon/app'

path = "#{__dirname}/fixtures/package_main"

describe 'app', ->

  describe 'add(path)', ->

    it 'adds', ->
      monitor = app.add path, 4001
      assert.equal Object.keys(app.monitors).length, 1
      assert.equal monitor.status, 'running'

  describe 'remove(path)', ->

    beforeEach ->
      monitor = app.add path, 4001
      
    it 'removes ', ->
      monitor = app.remove path
      assert.equal Object.keys(app.monitors).length, 0
      assert.equal monitor.status, 'stopping'
