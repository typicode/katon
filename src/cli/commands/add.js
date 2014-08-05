var fs         = require('fs')
var mkdirp     = require('mkdirp')
var chalk      = require('chalk')
var pathToHost = require('../utils/path-to-host')
var config     = require('../../config')

module.exports = function(command, dir) {
  mkdirp.sync(config.hostsDir)

  command = command ? command.trim() : ''

  if (command === '') {
    return console.log(
        'Please specify a command\n'
      + 'katon add <command>'
    )
  }

  var host = pathToHost(dir ? dir : process.cwd())

  fs.writeFileSync(config.hostsDir + '/' + host + '.json', JSON.stringify(
    {
      command : command,
      cwd     : dir ? dir : process.cwd(),
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