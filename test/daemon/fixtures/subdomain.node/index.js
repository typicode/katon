var http = require('http')

http.createServer(function (req, res) {
  console.log('Received a request')
  res.writeHead(200, {'Content-Type': 'text/plain'})
  res.end('SUB');
}).listen(process.env.PORT, function() {
  console.log('listening on port', process.env.PORT)
})
