var fs         = require('fs')
var mkdirp     = require('mkdirp')
var chalk      = require('chalk')
var pathToHost = require('../utils/path-to-host')
var config     = require('../../config')

// add <cmd> [name]
module.exports = function(args) {
  mkdirp.sync(config.hostsDir)

  var command = args[0] ? args[0].trim() : ''

  if (command === '') {
    return console.log(
        'Please specify a command\n'
      + 'katon add <command>'
    )
  } 

  var host = args[1] ? args[1] : pathToHost(pathToHost(process.cwd()))

  fs.writeFileSync(config.hostsDir + '/' + host + '.json', JSON.stringify(
    {
      command : command,
      cwd     : process.cwd(),
      env     : {
        PATH: process.env.PATH
      }
    }
    , null, 2)
  )

  console.log(
    "Application is now availaible at %s",
    chalk.cyan('http://' + host + '.ka/')
  )
}