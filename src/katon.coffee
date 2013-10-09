require 'shelljs/global'
eco = require 'eco'

# This module is the katon CLI.
# It just creates/removes files, symlinks, etc...
# The daemon will be responsible of starting/stopping apps.
module.exports = 
  # Pow and Katon paths
  powPath: "#{env.HOME}/.pow"
  katonPath: "#{env.HOME}/.katon"
  launchAgentsPath: "#{env.HOME}/Library/LaunchAgents"

  # Link:
  # Creates a pow proxy and a symlink into katon path.
  link: (path = pwd())->
    name = path.split('/').pop()
    "4000".to "#{@powPath}/#{name}"
    mkdir "#{@katonPath}" unless test '-d', "#{@katonPath}"
    exec "ln -s #{path} #{@katonPath}"

  # Unlink:
  # Destroys what was created by link.
  unlink: (path = pwd()) ->
    name = path.split('/').pop()
    # NOTE: rm won't remove symlink so an exec is used instead.
    exec "rm #{@powPath}/#{name} #{@katonPath}/#{name}"

  # Install:
  # Renders katon.plist.eco with the good env variables and
  # put it in $HOME/Library/LaunchAgents/
  setup: ->
    template = cat "#{__dirname}/../plist/katon.plist.eco"
    plistContent = eco.render template,
      nodePath: which 'node'
      daemonPath: "#{__dirname}/../lib/daemon.js"
    plistContent.to "#{@launchAgentsPath}/katon.plist"