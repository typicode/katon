require 'shelljs/global'
shout = require 'shoutjs'
logan = require 'logan'
eco   = require 'eco'

logan.set
  info: ['\n  %\n', 'green']
  lsEntry: ['  % -> %', 'cyan . .']
  success: ['  %: %', '. green']
  error: ['  %: %', '. red']

# This module is the katon CLI.
# It just creates/removes files, symlinks, etc...
# The daemon will be responsible of starting/stopping apps.
module.exports = 
  # Pow and Katon paths
  powPath: "#{env.HOME}/.pow"
  katonPath: "#{env.HOME}/.katon"
  launchAgentsPath: "#{env.HOME}/Library/LaunchAgents"

  # Creates a pow proxy and a symlink into katon path.
  link: (path) ->
    name = path.split('/').pop()

    console.log()
    shout.to "#{@powPath}/#{name}", "4000"
    shout.mkdir "#{@katonPath}" unless test '-d', "#{@katonPath}"
    shout.exec "ln -s #{path} #{@katonPath}"
    logan.info "Application is now available at http://#{name}.dev"

  exec: (path, execString) ->
    shout.to "#{path}/.katon", execString if execString?

  # Destroys what was created by link.
  unlink: (pathOrName) ->
    name = pathOrName.split('/').pop()

    console.log()
    shout.exec "rm -f #{@powPath}/#{name} #{@katonPath}/#{name}"
    logan.info "Successfully removed #{name}"

  # Renders katon.plist.eco with the good env variables and
  # put it in $HOME/Library/LaunchAgents/
  start: ->
    template = cat "#{__dirname}/../../plist/katon.plist.eco"
    plistContent = eco.render template,
      nodePath: which 'node'
      daemonPath: "#{__dirname}/../lib/daemon.js"

    console.log()
    shout.to "#{@launchAgentsPath}/katon.plist", plistContent
    shout.exec "launchctl load -Fw #{@launchAgentsPath}/katon.plist"
    logan.info 'Katon daemon was successfully loaded'

  # Removes katon.plist from $HOME/Library/LaunchAgents/
  stop: ->
    console.log()
    shout.exec "launchctl unload #{@launchAgentsPath}/katon.plist"
    shout.rm "#{@launchAgentsPath}/katon.plist"
    logan.info 'Katon daemon was successfully unloaded'

  installPow: ->
    logan.info 'Installing Pow'
    shout.exec 'curl get.pow.cx | sh'

  uninstallPow: ->
    logan.info 'Uninstalling Pow'
    shout.exec 'curl get.pow.cx/uninstall.sh | sh'

  list: ->
    for link in ls "#{@katonPath}"
      target = exec(
        "readlink #{@katonPath}/#{link}"
        silent: true
      )
      .output
      .trim()
      logan.lsEntry(link, target)

  status: ->
    if which('pow')?
      logan.success 'Pow', 'installed'
    else
      logan.error 'Pow', 'not installed - try katon install-pow'

    if exec('launchctl list | grep katon', silent: true).output is ''
      logan.error 'Katon', 'not running - try katon load'
    else
      logan.success 'Katon', 'running'

    if which('nodemon')?
      logan.success 'Nodemon', 'installed'
    else
      logan.error 'Nodemon', 'not installed'

