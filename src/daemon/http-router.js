var http      = require('http')
var httpProxy = require('http-proxy')
var chalk     = require('chalk')
var procs     = require('./procs')
var render    = require('./utils/render')
var timer     = require('./utils/timer')
var util      = require('util')

function log(id, msg) {
  util.log(chalk.green('[router] ') + msg + ' ' + chalk.grey(id))
}

// For http://www.app.ka will ['www', 'app']
// For http://www.app.10.0.0.1.xip.io will return ['www', 'app']
function removeTopLevelDomain(host) {
  if (/.xip.io$/.test(host)) {
    return host.split('.').slice(0, -6)
  } else {
    return host.split('.').slice(0, -1)
  }
}

// For http://www.app.ka will return app
function getDomainId(host) {
  return removeTopLevelDomain(host).pop()
}

// For http://www.app.ka will return www.app
function getSubdomainId(host) {
  return removeTopLevelDomain(host).join('.')
}

module.exports.createServer = function() {

  var server = http.createServer()
  var proxy  = httpProxy.createProxyServer()

  server.on('request', function(req, res) {
    var host = req.headers.host

    log(host, 'Received request')

    if(/^index.ka$/.test(host) ||
       /^katon.ka$/.test(host)) {
      res.end(render('200.ejs', { procs: procs.list }))
      return
    }

    if (/.ka$/.test(host) || /.xip.io$/.test(host)) {

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
      res.end(render('200.ejs', { procs: procs.list }))

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
