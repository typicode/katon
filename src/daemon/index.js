var util    = require('util')
var chalk   = require('chalk')
var control = require('./control')

chalk.enabled = true

control.start()

process.on('SIGTERM', function() {
  util.log('Received SIGTERM')
  util.log('Stop')
})