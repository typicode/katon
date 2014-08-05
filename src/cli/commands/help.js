var fs = require('fs')

module.exports = function() {
  console.log(fs.readFileSync(__dirname + '/../doc/help.txt', 'utf-8'))
}