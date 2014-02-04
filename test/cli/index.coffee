assert = require 'assert'
sinon = require 'sinon'
emitter = require '../../src/cli/util/emitter'
cli = require '../../src/cli'

emitter.emit = sinon.spy()

# Helpers
runCmd = (commands = '') ->
  # Spy on all cli.commands
  for method of cli.commands
    cli.commands[method] = sinon.spy()
  # Run commands
  cli.run "node katon #{commands}".trim().split ' '

assertCalled = (command) ->
  assert cli.commands[command].called, "#{command} wasn't called"

assertCalledWith = (command, args...) ->
  assert cli.commands[command].calledWith(args...),
    "#{command} called with #{cli.commands[command].args} instead of #{args}"

# Tests
describe 'cli', ->

  describe 'link', ->

    before -> runCmd 'link'

    it 'should call commands.link', ->
      assertCalledWith 'link', process.cwd()

  describe 'link foo', ->

    before -> runCmd 'link foo'

    it 'should call commands.link', ->
      assertCalledWith 'link', process.cwd(), 'foo'

  describe 'link foo bar', ->

    before -> runCmd 'link foo bar'

    it 'should call commands.link', ->
      assertCalledWith 'link', process.cwd(), 'foo bar'

  describe 'unlink', ->

    before -> runCmd 'unlink'

    it 'should call commands.unlink', ->
      assertCalledWith 'unlink', process.cwd()

  describe 'unlink <app>', ->

    before -> runCmd 'unlink foo'

    it 'should call commands.unlink with <app> name', ->
      assertCalledWith 'unlink', 'foo'

  describe 'list', ->

    before -> runCmd 'list'

    it 'should call commands.list', ->
      assertCalled 'list'

  describe 'start', ->

    before -> runCmd 'start'

    it 'should call commands.start', ->
      assertCalled 'start'

  describe 'stop', ->

    before -> runCmd 'stop'

    it 'should call commands.stop', ->
      assertCalled 'stop'

  describe 'restart', ->

    before -> runCmd 'restart'

    it 'should call commands.stop then commands.start', ->
      assertCalled 'stop'
      assertCalled 'start'

  describe 'install-pow', ->

    before -> runCmd 'install-pow'

    it 'should call commands.installPow', ->
      assertCalled 'installPow'

  describe 'uninstall-pow', ->

    before -> runCmd 'uninstall-pow'

    it 'should call commands.uninstallPow', ->
      assertCalled 'uninstallPow'

  describe 'help', ->

    before -> runCmd 'help'

    it 'should call commands.help', ->
      assertCalled 'help'

  describe '--version', ->

    before -> runCmd '--version'

    it 'should call commands.version', ->
      assertCalled 'version'

  describe 'no args', ->

    before -> runCmd()

    it 'should call commands.help', ->
      assertCalled 'help'