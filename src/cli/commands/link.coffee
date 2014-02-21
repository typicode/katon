emitter = require '../util/emitter'
shell = require '../util/shell'
config = require '../config'
parameterize = require 'parameterize'

module.exports = (path, execString) ->
  name = parameterize(path.split('/').pop()).replace(/_/g,'-')

  unless test '-d', config.powPath
    emitter.emit 'error', """
      #{config.powPath} doesn't exist
      Please install Pow
    """

  shell.to "#{config.powPath}/#{name}", "4000"
  shell.mkdir "#{config.katonPath}" unless test '-d', "#{config.katonPath}"

  if test '-L', "#{config.katonPath}/#{name}"
    emitter.emit 'error', "There is already an application named #{name}"

  if execString?
    shell.to "#{path}/.katon", execString
    emitter.emit 'info', 'Created .katon'

  shell.exec "ln -s #{path} #{config.katonPath}/#{name}"
  emitter.emit 'info', "Application is now available at http://#{name}.dev"