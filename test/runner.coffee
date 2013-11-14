assert = require 'assert'
sinon = require 'sinon'
runner = require '../src/runner'

describe 'runner', ->

  before ->
    runner.forever = {}
    runner.forever.start = sinon.spy()
    rm '-rf', '/tmp/app'
    mkdir '/tmp/app'

  describe 'start(path, port)', ->

    before ->
      runner.start '/tmp/app', 4000

    it 'starts express app', ->
      assert runner.forever.start.called
      assert runner.forever.start.calledWith ['npm', 'start' ],
        max: 1
        silent: false
        watch: true
        watchDirectory: '/tmp/app'
        watchIgnoreDotFiles: true
        outFile: "/tmp/app/katon.logs"
        env:
          PORT: 4000
