assert = require 'assert'
p = require 'path'
config = require '../../../src/daemon/config'
util = require '../../../src/daemon/app/util'

config.nvmPath = "#{__dirname}/fixtures/.nvm"

# Turns /some/path/node-index into some > path > node index
humanizePath = (path) ->
  path.replace(/_/g, ' > ').replace /-/g, ' '

describe 'app/util', ->

  describe 'findDir(path, pattern)', ->

    it 'returns path that matches pattern', ->
      assert.equal util.findDir("#{__dirname}/fixtures/.nvm", 'v0.10*'),
        'v0.10.26'

  describe 'getNodePath(path)', ->

    # Helper
    assertNodePath = (path, expected) ->
      assert.equal util.getNodePath("#{__dirname}/fixtures/#{path}"), expected

    # Tests
    describe 'path contains .nvmrc', ->

      it 'returns ~/.nvm/v0.10/bin', ->
        assertNodePath 'nvm',
          "#{config.nvmPath}/v0.10.26/bin"

    describe 'path has no .nvmrc', ->

      it 'returns /usr/local/bin', ->
        assertNodePath 'static',
          "/usr/local/bin:#{p.dirname(process.execPath)}"

  describe 'getCommandLine(path)', ->

    # Helper
    assertCommandLine = (path, expected) ->
      describe humanizePath(path), ->
        it "returns #{expected}", ->
          actual = util.getCommandLine "#{__dirname}/fixtures/#{path}"
          assert.equal actual, expected

    # Tests
    assertCommandLine 'package_main', 'nodemon'

    assertCommandLine 'package_scripts_start_node-index', 'nodemon index'

    assertCommandLine 'package_scripts_start_foo-index', 'foo index'

    assertCommandLine 'katon_foo-$PORT', 'foo $PORT'

    assertCommandLine 'static', 'static --port $PORT'

  describe 'getRespawnArgs(path, port)', ->

    # Helper
    assertRespawnArgs = (path, expected) ->
      path = "#{__dirname}/fixtures/#{path}"

      describe humanizePath(path), ->

        it 'returns spawn args', ->

          actual = util.getRespawnArgs path, 4001

          assert.deepEqual actual.command, expected.command
          assert.equal actual.cwd, path
          assert.equal actual.env.PORT, 4001
          assert.equal actual.env.PATH.split(':')[0], expected.nodePath
          assert.equal actual.maxRestarts, -1
          assert.equal actual.sleep, 10*1000

    # Tests
    assertRespawnArgs 'package_scripts_start_node-index',
      command: [config.nodemonPath, 'index'],
      nodePath: '/usr/local/bin'

    assertRespawnArgs 'nvm',
      command: [config.nodemonPath],
      nodePath: "#{config.nvmPath}/v0.10.26/bin"

    assertRespawnArgs 'static',
      command: [config.staticPath, '--port', '4001'],
      nodePath: '/usr/local/bin'