var fs       = require('fs')
var path     = require('path')
var mkdirp   = require('mkdirp')
var block    = require('block')
var config   = require('../../config')

// Render templates from ../templates to dest 
module.exports = function(templateName, dest, options) {

  var template = block(fs.readFileSync(__dirname + '/../templates/' + templateName, 'utf-8'))
  var data     = template.render(config)

  mkdirp.sync(path.dirname(dest))
  fs.writeFileSync(dest, data, options)

}