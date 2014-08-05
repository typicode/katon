#!/usr/bin/env node
var isRoot         = require('is-root')
var updateNotifier = require('update-notifier')
var pkg            = require('../package.json')
var cli            = require('../src/cli')

if (!isRoot()) {
  updateNotifier({packageName: pkg.name, packageVersion: pkg.version}).notify()
}

cli.run(process.argv.slice(2))