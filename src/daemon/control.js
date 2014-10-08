var fs           = require('fs')
var chalk        = require('chalk')
var dnsServer    = require('./dns-server')
var routerServer = require('./http-router')
var procs        = require('./procs')
var config       = require('../config')
var util         = require('util')

function log(str) {
  util.log(chalk.red('[daemon] ') + str)
}

module.exports = {

  start: function() {
    log('Start')

    this.katon = routerServer.createServer()
    this.dns   = dnsServer.createServer()

    log('Loading procs')
    procs.load()

    log('Starting DNS server on port ' + config.dnsPort)
    this.dns.listen(config.dnsPort, function() {
      log('DNS server started')
    })

    log('Starting katon server on port ' + config.katonPort)
    this.katon.listen(config.katonPort, function() {
      log('Katon server started')
    })
  },

  stop: function(callback) {
    log('Stop')

    this.katon.close(function() {
      log('Katon server stopped')
    })

    this.dns.close(function() {
      log('DNS server stopped')
    })

    for (var id in procs.list) {
      procs.list[id].stop()
    }

    setTimeout(callback, 1000)
  }
}
