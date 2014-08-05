var http      = require('http')
var httpProxy = require('http-proxy')

module.exports = {
  createServer: function() {

    var server = http.createServer()
    var proxy  = httpProxy.createProxyServer()

    server.forward = function(req, res, port, delay) {
      var target = { target : 'http://localhost:' + port }

      setTimeout(function() {
        proxy.web(req, res, target, function(err) {
          if (err) {
            setTimeout(function() {
              proxy.web(req, res, target, function(err) {
                server.emit('error', err, req, res)
              })
            }, delay)
          }
        })
      }, delay)
    }

    return server
  }
}
