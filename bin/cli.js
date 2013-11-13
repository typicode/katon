#!/usr/bin/env node

var program = require('commander');
var katon = require('../lib/katon.js')

program
  .version('0.0.1')
  .option('link', 'Link the current dir')
  .option('unlink', 'Unlink the current dir')
  .option('load', 'load katon daemon')
  .option('unload', 'unload katon daemon')
  .option('install-pow', 'Install or update pow')
  .parse(process.argv);

if (program.args.length === 0) program.help();
if (program.link) katon.link();
if (program.unlink) katon.unlink();
if (program.load) katon.load();
if (program.unload) katon.unload();
if (program.installPow) katon.installPow();