assert = require 'assert'
sinon = require 'sinon'
runner = require '../src/runner'

describe 'runner', ->

  before ->
    runner.forever = {}
    runner.forever.start = sinon.spy()
    rm '-rf', '/tmp/app'
    mkdir '/tmp/app'

  describe 'start(command, port)', ->

    before ->
      '{"scripts": {"start": "node app"}}'.to '/tmp/app/package.json'
      runner.start '/tmp/app', 4000

    it 'starts express app', ->
      assert runner.forever.start.called

  describe 'getForeverOptions(path, port)', ->

    beforeEach ->
      sinon.stub(runner, 'getCommand').returns 'node app'

    afterEach ->
      runner.getCommand.restore()

    it 'should return forever start options', ->
      actual = runner.getForeverOptions('/tmp/app', 4000)
      expected =
        sourceDir: '/tmp/app'
        max: 1
        silent: false
        outFile: "/tmp/app/katon.logs"
        env:
          PORT: 4000

      assert.deepEqual actual, expected

  describe 'getCommand(path)', ->

    describe 'directory has a package.json', ->

      describe 'has a start attribute', ->

        beforeEach ->
          '{"scripts": {"start": "node app"}}'.to '/tmp/app/package.json'

        describe 'and nodemon is installed', ->

          beforeEach ->
            sinon.stub(global, 'which').withArgs('nodemon').returns('/some/path')

          afterEach ->
            which.restore()

          it 'should replace node with nodemon', ->
            assert.equal runner.getCommand('/tmp/app'), 'nodemon app'

        describe 'and nodemon isn\'t installed', ->

          beforeEach ->
            sinon.stub(global, 'which').withArgs('nodemon').returns()

          afterEach ->
            which.restore()

          it 'should return start content', ->
            assert.equal runner.getCommand('/tmp/app'), 'node app'

      describe 'has a main field and no start field', ->

        beforeEach ->
          '{"main": "index"}'.to '/tmp/app/package.json'

        describe 'and nodemon is installed', ->

          beforeEach ->
            sinon.stub(global, 'which').withArgs('nodemon').returns('/some/path')

          afterEach ->
            which.restore()

          it 'should use nodemon to start the main script', ->
            assert.equal runner.getCommand('/tmp/app'), 'nodemon index'

        describe 'and nodemon isn\'t installed', ->

          beforeEach ->
            sinon.stub(global, 'which').withArgs('nodemon').returns()

          afterEach ->
            which.restore()

          it 'should use node to start the main script', ->
            assert.equal runner.getCommand('/tmp/app'), 'node index'

      describe 'path contains .katon and package.json', ->

        beforeEach ->
          '{"scripts": {start": "node app"}}'.to '/tmp/app/package.json'
          'grunt'.to '/tmp/app/.katon'

        it 'should return .katon content', ->
          assert.equal runner.getCommand('/tmp/app'), 'grunt'

    describe 'directory has no package.json', ->

      beforeEach ->
        rm '/tmp/app/package.json'

      describe 'has a .katon file', ->

        beforeEach ->
          'grunt'.to '/tmp/app/.katon'

        it 'should return .katon content', ->
          assert.equal runner.getCommand('/tmp/app'), 'grunt'

      describe 'has no katon file', ->

        beforeEach ->
          rm '/tmp/app/.katon'

        it 'should return .katon content', ->
          assert.equal runner.getCommand('/tmp/app'), 'static'