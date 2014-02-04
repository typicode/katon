assert = require 'assert'
commander = require '../../src/daemon/commander'

packagePath = '/tmp/app/package.json'
katonPath = '/tmp/app/.katon'

assertCommand = (path, command) ->
  assert.equal commander.getCommand(path, 1337), "PORT=1337 #{command}"

describe 'commander', ->

  before ->
    rm '-rf', '/tmp/app'
    mkdir '/tmp/app'

  describe 'getCommand(path, port)', ->

    describe 'path contains a package.json', ->

      describe 'has a start field which use node', ->

        beforeEach ->
          '{"scripts": {"start": "node node_server"}}'.to packagePath

        it 'should replace node with nodemon', ->
          assertCommand '/tmp/app', "#{commander.nodemon} node_server"

      describe 'has a start field which doesn\'t use node', ->

        beforeEach ->
          '{"scripts": {"start": "foo app"}}'.to packagePath

        it 'should return start script', ->
          assertCommand '/tmp/app', 'foo app'

      describe 'has a main field and no start field', ->

        beforeEach ->
          '{"main": "index"}'.to packagePath

        it 'should use nodemon without args to start the main script', ->
          assertCommand '/tmp/app', "#{commander.nodemon}"

      describe 'has no main field and no start field', ->

        beforeEach ->
          '{}'.to packagePath

        it 'should use static', ->
          assertCommand '/tmp/app', "#{commander.static} --port 1337"

      describe 'path contains .katon and package.json', ->

        beforeEach ->
          '{"scripts": {start": "node app"}}'.to packagePath
          'grunt --port $PORT'.to katonPath

        it 'should return .katon content and replace $PORT', ->
          assertCommand '/tmp/app', "grunt --port 1337"

    describe 'path has no package.json', ->

      beforeEach ->
        rm packagePath

      describe 'has a .katon file', ->

        beforeEach ->
          'grunt'.to katonPath

        it 'should return .katon content', ->
          assertCommand '/tmp/app', "grunt"

      describe 'has no katon file', ->

        beforeEach ->
          rm katonPath

        it 'should use static to serve directory', ->
          assertCommand '/tmp/app', "#{commander.static} --port 1337"
