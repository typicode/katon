module.exports = {

  '-v'        : require('./commands/version'),
  '--version' : require('./commands/version'),

  help        : require('./commands/help'),

  add         : require('./commands/add'),
  rm          : require('./commands/rm'),
  list        : require('./commands/list'),
  open        : require('./commands/open'),
  status      : require('./commands/status'),
  start       : require('./commands/start'),
  stop        : require('./commands/stop'),
  install     : require('./commands/install'),
  uninstall   : require('./commands/uninstall'),

  migrate     : require('./commands/migrate'),

  run: function(array) {
    var command = array[0]
    var option  = array[1]
    if (this[command]) {
      this[command](option);
    } else {
      this.help()
    }
  }
}