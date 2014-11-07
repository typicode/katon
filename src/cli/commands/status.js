var chalk  = require('chalk')
var got    = require('got')
var sh     = require('shelljs')
var config = require('../../config.js')

module.exports = function() {
  console.log('Checking that katon daemon is loaded...')

  var output = sh.exec('launchctl list | grep \'katon\'', { silent: true }).output
  daemonLoaded = output.indexOf('katon\n') !== -1

  if (daemonLoaded) {
    console.log(chalk.green('OK'))
  } else {
    return console.log(chalk.red('KO daemon is not loaded, try `katon start`'))
  }

  console.log('Checking .ka domain...')
  
  got('http://index.ka', function(err, data, res) {
    if (err) {
      console.log(chalk.red('KO try `sudo katon install`'))
    } else {
      console.log(chalk.green('OK'))
    }
  })
}