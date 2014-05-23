fs     = require 'fs.extra'
sinon  = require 'sinon'
config = require '../../../src/config'
common = require '../../../src/cli/common'
link   = require '../../../src/cli/controls/link'

describe 'link', ->

  describe 'create(path)', ->

    beforeEach ->
      fs.mkdirpSync  = sinon.spy()
      fs.symlinkSync = sinon.spy()
      common.create  = sinon.spy()

    it 'should link', ->
      link.create '/some/app'
      sinon.assert.calledWith fs.mkdirpSync, config.katonDir
      sinon.assert.calledWith fs.symlinkSync, '/some/app', "#{config.katonDir}/app"

    it 'should not overwrite a link', ->
      fs.existsSync = sinon
        .stub()
        .withArgs("#{config.katonDir}/app")
        .returns true
      
      link.create '/some/app'
      sinon.assert.notCalled fs.mkdirpSync
      sinon.assert.notCalled fs.symlinkSync
      sinon.assert.notCalled common.create

  describe 'remove(path)', ->

    beforeEach ->
      common.remove = sinon.spy()

    it 'should remove symlink', ->
      link.remove '/some/app'
      sinon.assert.calledWith common.remove, "#{config.katonDir}/app"