chalk = require 'chalk'
optimist = require 'optimist'
emitter = require './util/emitter'

# Require CLI config
config = require './config'

# Logs
emitter.on 'log', (message) ->  console.log message
emitter.on 'info', (message) ->  console.info chalk.cyan(message)
emitter.on 'warn', (message) ->  console.warn chalk.yellow(message)
emitter.on 'debug', (message) ->  console.log chalk.gray(message)
emitter.on 'error', (message) ->  console.error chalk.red(message)

# Exit 1 on error
emitter.on 'error', -> exit 1

module.exports =
  commands:
    version: require './commands/version'
    help: require './commands/help'
    link: require './commands/link'
    unlink: require './commands/unlink'
    list: require './commands/list'
    start: require './commands/start'
    stop: require './commands/stop'
    installPow: require './commands/install_pow'
    uninstallPow: require './commands/uninstall_pow'
    status: require './commands/status'
    open: require './commands/open'

  run: (argv) ->
    argv = optimist.parse argv
    argv.verbose = argv.verbose || argv.V

    emitter.removeAllListeners('debug') unless argv.verbose

    if argv.version
      return @commands.version()

    if 'help' in argv._ or argv._.length is 2
      return @commands.help()

    if 'link' in argv._
      path = process.cwd()
      if argv._.length >= 4
        return @commands.link path, argv._.slice(3).join(' ')
      else
        return @commands.link path

    if 'unlink' in argv._
      if argv._.length >= 4
        appName = argv._[3]
        return @commands.unlink appName
      else
        return @commands.unlink process.cwd()

    if 'list' in argv._
      return @commands.list()

    if 'start' in argv._
      return @commands.start()

    if 'stop' in argv._
      return @commands.stop()

    if 'restart' in argv._
      @commands.stop()
      @commands.start()
      return

    if 'install-pow' in argv._
      return @commands.installPow()

    if 'uninstall-pow' in argv._
      return @commands.uninstallPow()

    if 'status' in argv._
      return @commands.status()

    if 'open' in argv._
      path = process.cwd()
      return @commands.open path

    return @commands.help()
