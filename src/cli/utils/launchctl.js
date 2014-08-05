var fs     = require('fs')
var sh     = require('shelljs')
var rimraf = require('rimraf')
var render = require('./render')

module.exports = {
  
  create: function(templateName, dest) {
    render(templateName, dest, { mode: 33188 })
    var result = sh.exec('launchctl load -Fw ' + dest)
    if (result.code !== 0) console.log(result.output)
  },
  
  remove: function(filename) {
    if (fs.existsSync(filename)) {
      var result = sh.exec('launchctl unload ' + filename)
      if (result.code !== 0) console.log(result.output)
      rimraf.sync(filename)
    }
  }
}