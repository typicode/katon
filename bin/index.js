#!/usr/bin/env node
var updateNotifier = require('update-notifier')
var cli = require('../lib/cli/')

notifier = updateNotifier({packagePath: '../package'})

if (notifier.update) notifier.notify()

cli.run(process.argv.slice(2))
console.log()
