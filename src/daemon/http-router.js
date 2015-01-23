var http      = require('http')
var httpProxy = require('http-proxy')
var net       = require('net')
var address   = require('network-address')
var chalk     = require('chalk')
var procs     = require('./procs')
var render    = require('./utils/render')
var timer     = require('./utils/timer')
var util      = require('util')

// Logger
function log(id, msg, err) {
  var str = chalk.green('[router]') + ' ' + msg
  str += err ? '[' + err + '] ' : ' '
  str += chalk.grey(id)
  util.log(str)
}

// For http://www.app.ka will return ['www', 'app']
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

// Find proc based on host name
function getProc(host) {
  var domainId = getDomainId(host)
  var subdomainId = getSubdomainId(host)

  if (procs.list[subdomainId]) {
    return procs.list[subdomainId]
  } else {
    return procs.list[domainId]
  }
}

// Return true if proc exist
function procExists(host) {
  return typeof getProc(host) != 'undefined'
}

// Find, start and return proc based on host name
function startProc(host) {
  var proc = getProc(host)
  try {
    proc.start()
  } catch (e) {
    util.log(host, 'Can\'t start proc', e)
  }
  return proc
}

module.exports.createServer = function() {

  var server = http.createServer()
  var proxy = httpProxy.createProxyServer()

  // WebSocket
  server.on('upgrade', function(req, socket, head) {
    var host = req.headers.host
    var count = 0
    var max = 3

    log(host, 'WebSocket request received')

    // Test if proc exists for host
    if (!procExists(host)) {
      return log(host, 'Can\'t find proc')
    }

    // Start process
    var proc = startProc(host)

    // Forward
    function forward() {
      // proxy.ws can be only used once, so we're trying to make a TCP connect
      // before to know if port is open
      var client = net.connect({port: proc.env.PORT}, function() {
        // WebSocket request can be proxied, destroy TCP socket
        client.destroy()
        log(host, 'Proxying to ws://127.0.0.1:' + proc.env.PORT)
        proxy.ws(req, socket, head,
          { target: 'ws://127.0.0.1:' + proc.env.PORT },
          function(err) {
            log(host, 'Can\'t proxy WebSocket request')
          }
        )
      })

      client.on('error', function(err) {
        log(host, 'Can\'t connect to ws://127.0.0.1:' + proc.env.PORT, err)
        count += 1
        if (count <= max) {
          log(host, 'retry in 1 second')
          setTimeout(function() {
            forward()
          }, 1000)
        }
      })
    }

    forward()
  })

  // HTTP
  server.on('request', function(req, res) {
    var host = req.headers.host
    var count = 0
    var max = 3

    log(host, 'HTTP request received')

    // Render katon home
    var domain = getDomainId(host)
    if (domain === 'index' || domain === 'katon') {
      return res.end(render('200.ejs', {
        procs: procs.list,
        ip: address()
      }))
    }

    // Verify host is set and valid
    if (!(/.ka$/.test(host) || /.xip.io$/.test(host))) {
      log(host, 'Not a valid Host')
      res.statusCode = 200
      return res.end(render('200.ejs', {
        procs: procs.list,
        ip: address()
      }))
    }

    // Test if proc exists for host
    if (!procExists(host)) {
      log(host, 'Can\'t find proc')
      res.statusCode = 404
      return res.end(render('404.html'))
    }

    // Start process
    var proc = startProc(host)

    // Proxy request
    function forward() {
      log(host, 'Proxying to http://127.0.0.1:' + proc.env.PORT)
      proxy.web(req, res, {
        target: 'http://127.0.0.1:' + proc.env.PORT
      }, function(err, req, res) {
        // If address is in use stop
        if (err.code === 'EADDRINUSE') {
          log(host, err.code + ' check that port is not in use')
          res.statusCode = 502
          return res.end(render('502.html'))
        }

        // Else retry
        log(host, 'Can\'t connect, retry in 1 second [' + err + ']')
        count += 1
        if (count <= max) {
          setTimeout(function() {
            forward()
          }, 1000)
        } else {
          log(host, 'Can\'t connect: ' + err)
          res.statusCode = 502
          res.end(render('502.html'))
        }
      })
    }

    forward()
  })

  return server
}
