require 'shelljs/global'

# This module is the katon CLI.
# It just creates/removes files, symlinks, etc...
# The daemon will be responsible of starting/stopping apps.
module.exports = 
  # Pow and Katon paths
  powPath: "#{env.HOME}/.pow"
  katonPath: "#{env.HOME}/.katon"

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
