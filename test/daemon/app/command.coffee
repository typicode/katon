assert = require 'assert'
config = require '../../../src/config'
command = require '../../../src/daemon/app/command'

assertCommand = (path, expected) ->
  it "#{path} returns #{expected}", ->
    assert.deepEqual command.get("#{__dirname}/fixtures/#{path}", 4001),
      expected.split(' ')

describe 'app/command', ->

  describe 'get(path, port)', ->

    assertCommand 'nvm/nvmrc',
      config.nodemonPath

    assertCommand 'nvm/default',
      config.nodemonPath

    assertCommand 'node/package_main',
      config.nodemonPath

    assertCommand 'node/package_scripts_start_node-index',
      "#{config.nodemonPath} index"

    assertCommand 'node/package_scripts_start_foo-index',
      'foo index'

    assertCommand 'node/katon_foo-$PORT',
      'foo 4001'

    assertCommand 'node/package_syntax-error',
      "#{config.staticPath} --port 4001"

    assertCommand 'static',
      "#{config.staticPath} --port 4001"
