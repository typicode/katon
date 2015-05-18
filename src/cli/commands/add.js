var fs         = require('fs')
var minimist   = require('minimist')
var mkdirp     = require('mkdirp')
var chalk      = require('chalk')
var pathToHost = require('../utils/path-to-host')
var config     = require('../../config')

// add <cmd> [name] -e [ENV] -e [ENV]
module.exports = function(args) {
  // Make sure hosts dir exists
  mkdirp.sync(config.hostsDir)

  // Parse args
  args = minimist(args, {
    string: ['env'],
    alias: { e: 'env' }
  })

  // Get command
  var command = args._[0] ? args._[0].trim() : ''

  if (command === '') {
    return console.log(
        'Please specify a command\n'
      + 'katon add <command>'
    )
  }

  // Get host name
  var host = args._[1] ? args._[1] : pathToHost(process.cwd())

  // Create env
  var env = {
    PATH: process.env.PATH
  }

  if (typeof args.env === 'string') args.env = [args.env]

  for (var i in args.env) {
    var e = args.env[i]

    if (e === 'PATH') continue

    if (process.env.hasOwnProperty(e)) {
      env[e] = process.env[e]
    } else {
      return console.log('Can\'t find ' + e + ' environment variable')
    }
  }

  // Create host file
  fs.writeFileSync(config.hostsDir + '/' + host + '.json', JSON.stringify(
    {
      command : command,
      cwd     : process.cwd(),
      env     : env
    }
    , null, 2)
  )

  console.log(
    "Application is now availaible at %s",
    chalk.cyan('http://' + host + '.ka/')
  )
}
