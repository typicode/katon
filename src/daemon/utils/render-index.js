var fs         = require('fs')
var util       = require('util')
var block      = require('block')
var tildify    = require('tildify')
var config     = require('../../config')
var listHosts  = require('../../cli/utils/list-hosts')

module.exports = function(callback) {

  var templateDir  = __dirname + '/../templates'
  var templatePath = templateDir + '/200.html'
  var layoutPath   = templateDir + '/layout.html'

  try {
    var data   = listHosts()
    var page   = fs.readFileSync(templatePath, 'utf-8')
    var layout = fs.readFileSync(layoutPath, 'utf-8')

    page = block(page).render({ yield: format(data) })

    return block(layout).render({ yield: page })
  } catch(e) {
    util.log('Unexpected error: ' + e)
    return e
  }

}

function format(data) {
  var itemTemplate = ['<li>',
                        '<a class="app" href="http://%s.ka/">%s</a>',
                        '%s',
                        '<small>%s</small>',
                      '</li>'].join('')
  var result = ''

  data.forEach(function(name) {
    var appName = name.replace('.json', '')
    var filename = config.hostsDir + '/' + name
    var host = JSON.parse(fs.readFileSync(filename))

    result += util.format(itemTemplate,
                          appName,
                          appName,
                          host.command,
                          tildify(host.cwd))
  });

  return '<ul>' + result + '</ul>'
}
