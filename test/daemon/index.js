var setup  = require('../setup')()
var helper = require('./helper')

describe('Katon', function() {
  this.timeout(10000);

  before(function(done) {
    // This will start daemon
    require('../../src/daemon')
    setTimeout(done, 1000)
  })

  after(function(done) {
    require('../../src/daemon/control').stop()
    setTimeout(done, 1000)
  })

  it('Doesn\'t add node > GET http://node.ka', function(done) {
    helper.add('node') // no command provided

    helper.GET('node.ka', {
      status: 404
    }, done)
  })

  it('Add node > GET http://node.ka', function(done) {
    helper.add('node', 'node index.js')

    helper.GET('node.ka', {
      status: 200,
      body: 'OK'
    }, done)
  })

  it('Remove node > GET http://node.ka', function(done) {
    helper.remove('node')

    helper.GET('node.ka', {
      status: 404
    }, done)
  })

  it('Add node > GET http://subdomain.node.ka', function(done) {
    helper.add('subdomain.node', 'node index.js')

    helper.GET('subdomain.node.ka', {
      status: 200,
      body: 'OK'
    }, done)
  })

  it('Add node > GET http://subdomain.node.ka', function(done) {
    helper.add('node', 'node index.js')

    helper.GET('notsubdomain.node.ka', {
      status: 404
    }, done)
  })

  it('Add node-slow > GET http://node-slow.ka', function(done) {
    helper.add('node-slow', 'node index.js')

    helper.GET('node-slow.ka', {
      status: 502
    }, done)
  })

  it('GET http://node-slow.ka (reload)', function(done) {
    setTimeout(function() {
      helper.GET('node-slow.ka', {
        status: 200
      }, done)
    }, 5500)
  })

  it('add python > GET http://python.ka', function(done) {
    helper.add('python', 'python -m SimpleHTTPServer $PORT')

    helper.GET('python.ka', {
      status: 200
    }, done)
  })

  it('remove python > GET http://python.ka', function(done) {
    helper.remove('python')

    helper.GET('python.ka', {
      status: 404
    }, done)
  })

  it('Add non existing path', function(done) {
    helper.add('foo', 'node')

    helper.GET('foo.ka', {
      status: 502
    }, done)
  })

  it('GET http://localhost', function(done) {
    helper.GET('localhost', {
      status: 200
    }, done)
  })

  it('GET http://127.0.0.1', function(done) {
    helper.GET('127.0.0.1', {
      status: 200
    }, done)
  })

})
