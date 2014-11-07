var path = require('path')
var HOME = process.env.HOME

module.exports = {
  nodePath          : process.execPath,

  dnsPort           : 13375,
  httpsProxyPort    : 30900,
  httpPort         : 31000,

  resolverPath      : '/etc/resolver/ka',

  firewallPlistPath : '/Library/LaunchDaemons/katon.firewall.plist',
  daemonPlistPath   : HOME + '/Library/LaunchAgents/katon.plist',
  hostsDir          : HOME + '/.katon/hosts',
  logsDir           : HOME + '/.katon/logs',
  daemonPath        : path.resolve(__dirname + '/daemon/index'),
  daemonLogPath     : HOME + '/.katon/daemon.log'
}
