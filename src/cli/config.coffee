require 'shelljs/global'

# Add missing paths if daemon is run by launchd
env.PATH = env.PATH + ':/usr/local/bin:/usr/local/share/npm/bin'

module.exports =
  powPath: "#{env.HOME}/.pow"
  katonPath: "#{env.HOME}/.katon"
  launchAgentsPath: "#{env.HOME}/Library/LaunchAgents"