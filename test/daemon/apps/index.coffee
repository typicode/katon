# assert = require 'assert'
# sinon  = require 'sinon'
# config = require '../../../src/config'
# App    = require '../../../src/daemon/app/'
# apps   = require '../../../src/daemon/apps/'

# describe 'apps', ->

#   beforeEach ->
#     sinon.spy App, 'create'
#     apps.port = config.proxyPort
#     apps.list = {}

#   afterEach ->
#     App.create.restore()

#   describe 'add(path)', ->

#     it 'creates and adds app to app list', ->
#       apps.add '/app/one'
#       assert apps.list['/app/one']
#       assert App.create.calledWith '/app/one', config.proxyPort + 1

#       apps.add '/app/two'
#       assert apps.list['/app/two']
#       assert App.create.calledWith '/app/two', config.proxyPort + 2

#   describe 'remove(path)', ->

#     it 'stops and removes app from list', ->
#       apps.add '/app/one'

#       apps.remove '/app/one'
#       assert.deepEqual apps.list, {}

#       apps.add '/app/two'
#       assert.equal Object.keys(apps.list).length, 1
#       assert App.create.calledWith '/app/two', config.proxyPort + 2