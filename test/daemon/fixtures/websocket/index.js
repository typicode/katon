var WebSocketServer = require('ws').Server
var wss = new WebSocketServer({ port: process.env.PORT })

wss.on('connection', function() {
  console.log('Connection')
})
