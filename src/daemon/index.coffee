chalk = require 'chalk'
daemon = require './daemon'

chalk.enabled = true

daemon.init()
daemon.watch()