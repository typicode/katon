assert = require 'assert'
sinon = require 'sinon'
program = require '../src/program'

describe 'program', ->

  before ->
    program.katon.link = sinon.spy()

  describe 'link', ->

    before ->
      program.run ['node', 'katon', 'link']

    it 'should call katon.link', ->
      assert program.katon.link.called

  describe 'unlink', ->

    before ->
      program.run ['node', 'katon', 'unlink']

    it 'should call katon.unlink', ->
      assert program.katon.unlink.called