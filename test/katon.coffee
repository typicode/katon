assert = require 'assert'
katon = require '../src/katon'

describe 'katon', ->

  # Let's change katon paths so that everything is done in tmp...
  before ->
    katon.powPath = '/tmp/.pow'
    katon.katonPath = '/tmp/.katon'
  
  # Before each tests reset directories 
  beforeEach ->
    paths = ['/tmp/.pow', '/tmp/.katon', '/tmp/app']
    rm '-rf', paths
    mkdir paths

  describe 'link', ->

    beforeEach ->
      # katon.link should create the /tmp/.katon so it's removed before the test
      rm '-rf', '/tmp/.katon'
      katon.link '/tmp/app'

    it 'should create a proxy file in .pow', ->
      assert.equal cat('/tmp/.pow/app'), 4000

    it 'should create .katon directory', ->
      assert test '-e', "/tmp/.katon"

    it 'should create a symlink in .katon directory', ->
      assert test '-L', "/tmp/.katon/app"

  describe 'unlink', ->

    beforeEach ->
      exec "touch /tmp/.pow/app"
      exec "ln -s /tmp/app /tmp/.katon/app"
      katon.unlink '/tmp/app'

    it 'should rm the proxy in .pow', ->
      assert !test '-f', "/tmp/.pow/app"

    it 'should rm the symlink in .katon', ->
      assert !test '-L', "/tmp/.katon/app"