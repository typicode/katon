#!/usr/bin/env node

var program = require('commander');
var katon = require('../lib/katon.js')

program
  .version('0.0.1')
  .option('link', 'Link the current dir')
  .option('unlink', 'Unlink the current dir')
  .option('setup', 'Setup katon daemon')
  .parse(process.argv);

if (program.link) katon.link();
if (program.unlink) katon.unlink();
if (program.setup) katon.setup();