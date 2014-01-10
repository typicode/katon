assert = require 'assert'
sinon = require 'sinon'
program = require '../../src/cli/program'

# Test helpers
runCmd = (commands) ->
  program.run "node katon #{commands}".split ' '

assertCalled = (command) ->
  assert program.katon[command].called #, "katon.#{command} wasn't called"

assertCalledWith = (command, arg) ->
  assert program.katon[command].calledWith arg

# Tests
describe 'program', ->

  before ->
    for method of program.katon
      program.katon[method] = sinon.spy()

  describe 'link', ->

    before -> runCmd 'link'

    it 'should call katon.link', ->
      assertCalledWith 'link', process.cwd

  describe 'link --exec foo', ->

    before -> runCmd 'link --exec foo'

    it 'should call katon.link', ->
      assertCalledWith 'link', process.cwd

    it 'should call katon.exec', ->
      assertCalledWith 'exec', 'foo'

  describe 'unlink', ->

    before -> runCmd 'unlink'

    it 'should call katon.unlink', ->
      assertCalledWith 'unlink', process.cwd

  describe 'unlink --name <app>', ->

    before -> runCmd 'unlink --name foo'

    it 'should call katon.unlink with <app> name', ->
      assertCalledWith 'unlink', 'foo'

  describe 'list', ->

    before -> runCmd 'list'

    it 'should call katon.list', ->
      assertCalled 'list'

  describe 'start', ->

    before -> runCmd 'start'

    it 'should call katon.start', ->
      assertCalled 'start'

  describe 'stop', ->

    before -> runCmd 'stop'

    it 'should call katon.stop', ->
      assertCalled 'stop'

  describe 'status', ->

    before -> runCmd 'status'

    it 'should call katon.status', ->
      assertCalled 'status'

  describe 'help', ->

    before -> runCmd 'help'

    it 'should output help', ->
      assertCalled 'link'