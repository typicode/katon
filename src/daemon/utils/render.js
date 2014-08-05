var fs       = require('fs')
var util     = require('util')
var block    = require('block')

module.exports = function(templateName, callback) {

  var templateDir  = __dirname + '/../templates'
  var templatePath = templateDir + '/' + templateName
  var layoutPath   = templateDir + '/layout.html'

  try {
    var data   = fs.readFileSync(templatePath, 'utf-8')
    var layout = fs.readFileSync(layoutPath, 'utf-8')

    return block(layout).render({ yield: data })
  } catch(e) {
    util.log('Unexpected error: ' + e)
    return e
  }

}  
