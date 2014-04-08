sinon = require 'sinon'
cli   = require '../../src/cli'

# modules that will be spied on
m =
  daemon  : require '../../src/cli/controls/daemon'
  link    : require '../../src/cli/controls/link'
  exec    : require '../../src/cli/controls/exec'
  help    : require '../../src/cli/controls/help'

describe 'cli', ->

  beforeEach ->
    for mod of m
      for func of m[mod]
        if typeof m[mod][func] is 'function'
          sinon.stub m[mod], func

  afterEach ->
    for mod of m
      for func of m[mod]
        if typeof m[mod][func] is 'function'
          m[mod][func].restore()

  it '<no args>', ->
    cli.run []
    sinon.assert.called m.help.usage

  it '<unknown>', ->
    cli.run ['unknown']
    sinon.assert.called m.help.usage

  it 'link', ->
    cli.run ['link']
    sinon.assert.calledWith m.link.create, process.cwd()
    sinon.assert.notCalled m.exec.create

  it 'link <exec>', ->
    cli.run ['link', 'python']
    sinon.assert.calledWith m.link.create, process.cwd()
    sinon.assert.calledWith m.exec.create, process.cwd(), 'python'

  it 'unlink', ->
    cli.run ['unlink']
    sinon.assert.calledWith m.link.remove, process.cwd()
    sinon.assert.calledWith m.exec.remove, process.cwd()

  it 'unlink <path>', ->
    cli.run ['unlink', '/some/path']
    sinon.assert.calledWith m.link.remove, '/some/path'
    sinon.assert.calledWith m.exec.remove, '/some/path'

  it 'list', ->
    cli.run ['list']
    sinon.assert.called m.link.list

  it 'open', ->
    cli.run ['open']
    sinon.assert.called m.link.open, process.cwd()

  it 'start', ->
    cli.run ['start']
    sinon.assert.called m.daemon.create
    sinon.assert.called m.daemon.load

  it 'stop', ->
    cli.run ['stop']
    sinon.assert.called m.daemon.unload
    sinon.assert.called m.daemon.remove

  it 'status', ->
    cli.run ['status']
    sinon.assert.called m.help.status
