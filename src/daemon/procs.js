var fs      = require('fs')
var path    = require('path')
var util    = require('util')
var respawn = require('respawn')
var extend  = require('xtend')
var mkdirp  = require('mkdirp')
var chalk   = require('chalk')
var tildify = require('tildify')
var parse   = require('shell-quote').parse
var config  = require('../../src/config')

var PORT = config.katonPort

function createLogger(id) {
  return function(str) {
    util.log(chalk.cyan('[procs ] ') + str + ' ' + chalk.gray(id))
  }
}

module.exports = {
  list: {},

  add: function(id, options) {
    var log = createLogger(id)
    var env = extend(process.env, options.env)

    log('Add')

    // Set PORT
    env.PORT = PORT += 2

    // Create proc and add it to the procs list
    var proc = this.list[id] = respawn({
      command     : parse(options.command, { PORT: env.PORT }),
      cwd         : options.cwd,
      env         : env,
      maxRestarts : -1,
      sleep       : 10*1000
    })

    // Ensure logs directory exist
    mkdirp.sync(config.logsDir)

    // Create log stream
    var logFile = config.logsDir + '/' + id + '.log'

    var out = fs.createWriteStream(logFile)
      .on('error', log)
      .on('open', function() {
        proc.stdio = ['ignore', out, out]
      })

    // Listen to proc events
    proc.on('start', function() {
        log('Start')
        out.write(
            '[katon] Starting ' + id + ' on port: '+ proc.env.PORT
          + ' using command: ' + mon.command.join(' ')
          + '\n'
        )
      })
      .on('exit', function() {
        log('Stop')
        // Empty log file on exit
        fs.writeFile(logFile, '', function() {})
      })
      .on('warn', log)

  },

  remove: function(id) {
    var log = createLogger(id)
    log('Remove')
    this.list[id].stop()
    delete this.list[id]
  },


  load: function() {
    var self = this

    fs.readdirSync(config.hostsDir).forEach(function(name) {
      if (/.json$/.test(name)) {
        var id      = name.replace('.json', '')
        var options = JSON.parse(fs.readFileSync(config.hostsDir + '/' + name))

        self.add(id, options)
      }
    })

    fs.watch(config.hostsDir, function(event, name) {
      var id   = name.replace('.json', '')
      var file = config.hostsDir + '/' + name

      if (fs.existsSync(file)) {
        var options = JSON.parse(fs.readFileSync(file))
        if (self.list[id]) self.remove(id)
        self.add(id, options)
      } else {
        self.remove(id)
      }
    })
  }
}
