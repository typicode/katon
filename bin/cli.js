#!/usr/bin/env node

var updateNotifier = require('update-notifier');

// Checks for available update and returns an instance
var notifier = updateNotifier({packagePath: '../package'});

if (notifier.update) {
  // Notify using the built-in convenience method
  notifier.notify();
}

var cli = require('../lib/cli');

cli.run(process.argv);