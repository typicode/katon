var http        = require('http')
var httpProxy   = require('http-proxy')
var chalk       = require('chalk')
var procs       = require('./procs')
var render      = require('./utils/render')
var renderIndex = require('./utils/render-index')
var timer       = require('./utils/timer')
var util        = require('util')

function log(id, msg) {
  util.log(chalk.green('[router] ') + msg + ' ' + chalk.grey(id))
}

// For http://www.app.ka will return app
function getDomainId(host) {
  return host.split('.').slice(-2, -1).pop()
}

// For http://www.app.ka will return www.app
function getSubdomainId(host) {
  return host.split('.').slice(0, -1).join('.')
}

module.exports.createServer = function() {

  var server = http.createServer()
  var proxy  = httpProxy.createProxyServer()

  server.on('request', function(req, res) {
    var host = req.headers.host

    log(host, 'Received request')

    if(/^index.ka$/.test(host) ||
       /^katon.ka$/.test(host)) {
      res.end(renderIndex())
      return
    }

    if (/.ka$/.test(host)) {

      var domainId = getDomainId(host)
      var subdomainId = getSubdomainId(host)

      if (procs.list[subdomainId]) {
        var id = subdomainId
        var proc = procs.list[subdomainId]
      } else {
        var id = domainId
        var proc = procs.list[domainId]
      }

      if (proc) {

        log(id, 'Found proc [' + proc.status + ']')

        var port   = proc.env.PORT
        var target = { target: 'http://127.0.0.1:' + port }

        try { proc.start() }
        catch(e) { log(id, e) }

        var delay = 2000

        log(id, 'Forwarding to ' + port)
        proxy.web(req, res, target, function() {
          log(id, 'Failed to forward, retry in ' + delay + ' ms')
          setTimeout(function() {
            proxy.web(req, res, target, function() {
              log(id, 'Failed to forward, last try in ' + delay + 'ms')
              setTimeout(function() {
                proxy.web(req, res, target)
              }, delay)
            })
          }, delay)
        })

        timer(proc.id, function() {
          log(id, 'No requests for 1 hour')
          proc.stop()
        })

      } else {

        log(id, 'Can\'t find proc')

        res.statusCode = 404
        res.end(render('404.html'))

      }

    } else {

      log('', 'No host')

      res.statusCode = 200
      res.end(renderIndex())

    }

  })

  proxy.on('error', function(err, req, res) {
    if (err.code === 'EADDRINUSE') {
      return log('', err.code + ' check that port is not in use')
    }

    var id = req.headers.host

    log(id, 'Can\'t connect: ' + err)
    res.statusCode = 502
    res.end(render('502.html'))
  })

  return server
}
