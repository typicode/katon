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

if (program.link)       { katon.link(); return; }
if (program.unlink)     { katon.unlink(); return; }
if (program.load)       { katon.load(); return; }
if (program.unload)     { katon.unload(); return; }
if (program.installPow) { katon.installPow(); return; }

program.help();