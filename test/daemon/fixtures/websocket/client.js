// Use it to test ./index.js
var WebSocket = require('ws')
var ws = new WebSocket('ws://127.0.0.1:' + process.env.PORT, {
  host: 'foo'
})

ws.on('open', function() {
  console.log('Open')
})
