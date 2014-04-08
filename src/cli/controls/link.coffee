p      = require 'path'
fs     = require 'fs.extra'
pad    = require 'pad'
chalk  = require 'chalk'
common = require '../common'
config = require '../../config'

getName = (path) ->
  # replace _ with - for valid domain name
  p.basename(path).replace /_/g, '-'

getLink = (path) ->
  "#{config.katonDir}/#{getName path}"

getPowProxy = (path) ->
  "#{config.powDir}/#{getName path}"

getUrl = (path) ->
  "http://#{getName path}.dev/"

module.exports =

  create: (path) ->
    name     = getName path
    url      = getUrl path
    link     = getLink path
    powProxy = getPowProxy path

    if fs.existsSync link
      err = "Already an application named #{chalk.red name} in #{chalk.red '~/.katon'}"
      console.log err

    else
      common.create powProxy, config.proxyPort

      console.log chalk.grey "create #{common.tilde link}"
      fs.mkdirpSync config.katonDir
      fs.symlinkSync path, link
      
      console.log "Application is now available at #{chalk.cyan url}"

  remove: (path) ->
    name     = getName path
    link     = getLink path
    powProxy = getPowProxy path

    common.remove powProxy
    common.remove link
    console.log "Successfully removed #{chalk.cyan name}"

  list: ->
    fs.mkdirpSync config.katonDir
    links = fs.readdirSync config.katonDir

    if links.length is 0
      console.log chalk.grey "No apps linked in #{common.tilde config.katonDir}"
    else
      for link in links
        url  = "http://#{link}.dev"
        dest = fs.readlinkSync "#{config.katonDir}/#{link}"

        if fs.existsSync dest
          console.log "#{chalk.cyan pad url, 30}  →  #{common.tilde dest} "
        else
          err = "#{dest} [doesn't exist]"
          console.log "#{chalk.red pad url, 30}  →  #{chalk.gray err}"

  open: (path) ->
    common.sh "open #{getUrl path}"

