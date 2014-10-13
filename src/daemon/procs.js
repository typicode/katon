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

function log(id, msg) {
  util.log(chalk.cyan('[procs ] ') + msg + ' ' + chalk.gray(id))
}

module.exports = {
  list: {},

  add: function(id, options) {
    log(id, 'Add')

    var env = extend(process.env, options.env)

    env.PATH = options.env.PATH
    env.PORT = PORT += 2

    var mon = respawn({
      command     : parse(options.command, { PORT: env.PORT }),
      cwd         : options.cwd,
      env         : env,
      maxRestarts : -1,
      sleep       : 10*1000
    })

    this.list[id] = mon

    mkdirp.sync(config.logsDir)
    var out = fs.createWriteStream(config.logsDir + '/' + id + '.log')
      .on('error', function(err) {
        log(id, err)
      })
      .on('open', function() {
        mon.stdio = ['ignore', out, out]
      })

    mon.on('start', function() {
        log(id, 'Start')
        out.write(
            '[katon] Starting ' + id + ' on port: '+ mon.env.PORT
          + ' using command: ' + mon.command.join(' ') + '\n'
        )
      })
      .on('exit', function() { log(id, 'Stop') })
      .on('warn', function(err) { log(id, err) })

  },

  remove: function(id) {
    log(id, 'Remove')
    this.list[id].stop()
    delete this.list[id]
  },


  load: function() {
    var self = this

    fs.readdirSync(config.hostsDir).forEach(function(name) {
      var id      = name.replace('.json', '')
      var options = JSON.parse(fs.readFileSync(config.hostsDir + '/' + name))

      self.add(id, options)
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