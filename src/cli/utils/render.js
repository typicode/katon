var fs     = require('fs')
var path   = require('path')
var mkdirp = require('mkdirp')
var ejs    = require('ejs')
var config = require('../../config')

// Render templates from ../templates to dest
module.exports = function(templateName, dest, options) {

  var template = fs.readFileSync(__dirname + '/../templates/' + templateName, 'utf-8')
  var data     = ejs.render(template, config)

  mkdirp.sync(path.dirname(dest))
  fs.writeFileSync(dest, data, options)

}
