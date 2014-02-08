require 'shelljs/global'
fs = require 'fs'
log = require './log'
proxy = require './proxy'
appManager = require './app_manager'

# If the daemon is run by launchd it will lack some paths
# so we're adding them right now
env.PATH = env.PATH + ':/usr/local/bin:/usr/local/share/npm/bin'

katonPath = appManager.katonPath

watch = ->
  fs.watch katonPath, (event, filename) ->
    if test '-L', "#{katonPath}/#{filename}"
      appManager.create filename
    else
      appManager.remove filename
   
    proxyTable = appManager.getProxyTable()
    proxy.reload proxyTable

start = ->
  for name in ls katonPath
    appManager.create name

start()
watch()