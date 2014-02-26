assert = require 'assert'
command = require '../../../src/daemon/app/command'
env = require '../../../src/daemon/app/env'
monitor = require '../../../src/daemon/app/monitor'

assertMonitor = (path) ->
  it "#{path} returns a respawn monitor", ->
    path = "#{__dirname}/fixtures/#{path}"
    mon = monitor.create path, 4001

    assert.deepEqual mon.command, command.get(path, 4001)
    assert.deepEqual mon.env, env.get(path, 4001)
    assert.equal mon.cwd, path
    assert.equal mon.maxRestarts, -1
    assert.equal mon.sleep, 10*1000


describe 'app/monitor', ->

  describe 'create(path, port)', ->

    assertMonitor "node/package_main",
    assertMonitor "node/katon_foo_$PORT"



