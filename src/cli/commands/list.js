var fs         = require('fs')
var chalk      = require('chalk')
var tildify    = require('tildify')
var listHosts  = require('../utils/list-hosts')
var config     = require('../../config.js')

module.exports = function() {
  listHosts().forEach(function(name) {
    var filename = config.hostsDir + '/' + name
    var host = JSON.parse(fs.readFileSync(filename))

    console.log(
      chalk.cyan(name.replace('.json', '')),
      host.command,
      chalk.grey(tildify(host.cwd))
    )
  })

  console.log()
  
  console.log(
    chalk.grey('Go to http://index.ka to view app list from your browser')
  )
}
