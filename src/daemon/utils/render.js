var fs   = require('fs')
var util = require('util')
var ejs  = require('ejs')

module.exports = function(templateName, context) {

  context = context || {}

  var templateDir  = __dirname + '/../templates'
  var templatePath = templateDir + '/' + templateName
  var layoutPath   = templateDir + '/layout.html'

  try {
    var template = fs.readFileSync(templatePath, 'utf-8')
    var layout   = fs.readFileSync(layoutPath, 'utf-8')

    return ejs.render(layout, {
      yield: ejs.render(template, context)
    })
  } catch(e) {
    util.log('Unexpected error: ' + e)
    return e.toString()
  }

}
