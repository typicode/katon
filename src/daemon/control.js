var fs         = require('fs')
var chalk      = require('chalk')
var util       = require('util')
var dnsServer  = require('./dns-server')
var httpsProxy = require('./https-proxy')
var httpRouter = require('./http-router')
var procs      = require('./procs')
var config     = require('../config')

function log(str) {
  util.log(chalk.red('[daemon] ') + str)
}

module.exports = {

  start: function() {
    log('Start')

    this.dns   = dnsServer.createServer()
    this.https = httpsProxy.createServer()
    this.http  = httpRouter.createServer()

    log('Loading procs')
    procs.load()

    log('Starting DNS server on port ' + config.dnsPort)
    this.dns.serve(config.dnsPort, function() {
      log('DNS server started')
    })

    log('Starting HTTPS server on port ' + config.httpsProxyPort)
    this.https.listen(config.httpsProxyPort, function() {
      log('HTTPS server started')
    })

    log('Starting HTTP server on port ' + config.httpPort)
    this.http.listen(config.httpPort, function() {
      log('HTTP server started')
    })
  },

  stop: function(callback) {
    log('Stop')

    this.http.close(function() {
      log('HTTP server stopped')
    })

    this.https.close(function() {
      log('HTTPS server stopped')
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
