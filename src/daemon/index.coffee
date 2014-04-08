chalk  = require 'chalk'
daemon = require './daemon'

# Enable colors in logs
chalk.enabled = true

daemon.init()
daemon.watch()