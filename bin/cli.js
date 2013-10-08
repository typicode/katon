#!/usr/bin/env node

var program = require('commander');
var katon = require('../lib/katon.js')

program
  .version('0.0.1')
  .option('link', 'Link the current dir')
  .option('unlink', 'Unlink the current dir')
  .parse(process.argv);

if (program.link) katon.link();
if (program.unlink) katon.unlink();