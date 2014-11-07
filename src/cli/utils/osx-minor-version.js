var sh = require('shelljs')

module.exports = function() {
  return +sh.exec('sw_vers -productVersion').output.split('.')[1]
}