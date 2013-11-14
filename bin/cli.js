#!/usr/bin/env node

var program = require('commander');
var katon = require('../lib/katon.js')

program
  .version('0.0.1')
  .option('link', 'link the current dir')
  .option('unlink', 'unlink the current dir')
  .option('load', 'load katon daemon')
  .option('unload', 'unload katon daemon')
  .option('list', 'list linked apps')
  .option('install-pow', 'install or update pow')
  .parse(process.argv);

if (program.link)       { katon.link(); return; }
if (program.unlink)     { katon.unlink(); return; }
if (program.load)       { katon.load(); return; }
if (program.unload)     { katon.unload(); return; }
if (program.list)       { katon.list(); return; }
if (program.installPow) { katon.installPow(); return; }

program.help();