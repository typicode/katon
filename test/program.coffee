assert = require 'assert'
sinon = require 'sinon'
program = require '../src/program'

describe 'program', ->

  before ->
    program.katon.link = sinon.spy()
    program.katon.exec = sinon.spy()
    program.katon.unlink = sinon.spy()

  describe 'link', ->

    before ->
      program.run ['node', 'katon', 'link']

    it 'should call katon.link', ->
      assert program.katon.link.called

  describe 'link --exec foo', ->

    before ->
      program.run ['node', 'link', '--exec', 'foo']

    it 'should call katon.link', ->
      assert program.katon.link.called

    it 'should call katon.exec', ->
      assert program.katon.exec.called

  describe 'unlink', ->

    before ->
      program.run ['node', 'katon', 'unlink']

    it 'should call katon.unlink', ->
      assert program.katon.unlink.called