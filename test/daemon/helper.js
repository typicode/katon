var rmrf    = require('rimraf')
var chalk   = require('chalk')
var config  = require('../../src/config')
var request = require('supertest')('http://localhost:' + config.httpPort)
var cli     = require('../../src/cli')

function log(str) {
  console.log()
  console.log(chalk.green(str))
  console.log()
}

module.exports = {
  
  GET: function(host, options, done) {
    setTimeout(function() {
      options.status = options.status ? options.status : 200
      
      log('GET http://' + host + ' expect ' + options.status)

      request
        .get('/')
        .set('Host', host)
        .expect(options.status ? options.status : 200)
        .end(done)
    }, 1000)
  },

  add: function(host, command) {
    log('CLI add host:' + host + ' command:' + command)
    process.cwd = function() {
      return __dirname + '/fixtures/' + host
    }
    command ? cli.add([command]) : cli.add([])
  },

  remove: function(host) {
    log('CLI remove host:' + host)
    cli.rm([host])
  }
  
}