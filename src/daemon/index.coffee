require 'shelljs/global'
_ = require 'underscore'
fs = require 'fs'
httpProxy = require 'http-proxy'
chalk = require 'chalk'
starter = require './starter'

# If the daemon is run by launchd it will lack some paths
# so we're adding them right now
env.PATH = env.PATH + ':/usr/local/bin:/usr/local/share/npm/bin'

katonPath = "#{env.HOME}/.katon"

# Initial state
port = 4001
apps = []
router = {}
proxyServer = null

add = (filename) ->
  console.log chalk.cyan("Add #{filename}")
  app =
    filename: filename
    port: port
    kill: starter.start("#{katonPath}/#{filename}", port)
  apps.push app
  port++

remove = (filename) ->
  console.log chalk.red("Remove #{filename}")
  console.log apps
  app = _.findWhere apps, filename: filename
  console.log app
  app.kill()
  apps = _.reject apps, (app) -> app.filename is filename

startApps = ->
  console.log chalk.cyan('Starting all apps')
  for filename, index in ls katonPath
    add filename

stopProxy = ->
  console.log chalk.red('Stopping katon proxy server')
  proxyServer.close() if proxyServer

startProxy = ->
  console.log chalk.green('Starting katon proxy server')
  apps.forEach (app) ->
    router["#{app.filename}.dev"] = "127.0.0.1:#{app.port}"
  proxyServer = httpProxy.createServer hostnameOnly: true, router: router
  proxyServer.listen 4000

reloadProxy = ->
  stopProxy()
  startProxy()

fs.watch katonPath, (event, filename) ->
  console.log "#{katonPath}/filename"
  if test '-L', "#{katonPath}/#{filename}"
    add filename
  else
    remove filename
  reloadProxy()

startApps()
startProxy()
