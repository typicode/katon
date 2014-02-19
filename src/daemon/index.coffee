require 'shelljs/global'
fs = require 'fs'
path = require 'path'
log = require './log'
proxy = require './proxy'
appManager = require './app_manager'

# If the daemon is run by launchd it will lack some paths
# so we're adding them right now
processPath = path.dirname process.execPath
env.PATH = "#{env.PATH}:/usr/local/bin:/usr/local/share/npm/bin:#{processPath}"

katonPath = appManager.katonPath

watch = ->
  fs.watch katonPath, (event, filename) ->
    if test '-L', "#{katonPath}/#{filename}"
      appManager.create filename
    else
      appManager.remove filename
   
    proxyTable = appManager.getProxyTable()
    proxy.load proxyTable

start = ->
  for name in ls katonPath
    appManager.create name

  proxyTable = appManager.getProxyTable()
  proxy.load proxyTable

start()
watch()