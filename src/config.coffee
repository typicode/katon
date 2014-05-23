path = require 'path'

HOME = process.env.HOME

module.exports =
  nodePath      : process.execPath
  binPath       : "#{__dirname}/../bin/index"

  httpPort      : 80
  dnsPort       : 13375
  proxyPort     : 4000
  powPort       : 20559

  resolverPath  : '/etc/resolver/ka'

  ruleNumber    : 90
  firewallPlist : "/Library/LaunchAgents/katon.firewall.plist"

  daemonPlist   : "#{HOME}/Library/LaunchAgents/katon.plist"

  nvmDir        : "#{HOME}/.nvm"
  katonDir      : "#{HOME}/.katon"

  daemonPath    : path.resolve "#{__dirname}/daemon/index"
  nodemonPath   : path.resolve "#{__dirname}/../node_modules/.bin/nodemon"
  staticPath    : path.resolve "#{__dirname}/../node_modules/.bin/static"
