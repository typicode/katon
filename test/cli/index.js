var setup  = require('../setup')()

var assert    = require('assert')
var fs        = require('fs')
var cli       = require('../../src/cli')
var config    = require('../../src/config')
var sh        = require('shelljs')

sh.exec = function() { return { code: 0, output: '' } }

// Mostly testing that it doesn't crash
// Integration testing is done in /test/daemon
describe('katon command-line interface', function() {
  it('install', function() {
    // root
    process.getuid = function() {
      return 0
    }

    cli.run(['install'])
    assert(fs.existsSync(config.resolverPath))
    assert(fs.existsSync(config.firewallPlistPath))
  })

  it('uninstall', function() {
    // root
    process.getuid = function() {
      return 0
    }

    cli.run(['uninstall'])
    assert(!fs.existsSync(config.resolverPath))
    assert(!fs.existsSync(config.firewallPlistPath))
  })

  it('start', function() {
    process.getuid = function() {
      return 1000
    }

    cli.run(['start'])
    assert(fs.existsSync(config.daemonPlistPath))
  })

  it('stop', function() {
    process.getuid = function() {
      return 1000
    }

    cli.run(['stop'])
    assert(!fs.existsSync(config.daemonPlistPath))
  })

  it('status', function() {
    cli.run(['status'])
  })

  it('list/add/list/rm', function() {
    cli.run(['list'])
    cli.run(['add', 'echo'])
    cli.run(['add', 'echo', 'foo'])
    cli.run(['add', 'echo', 'foo.bar'])
    cli.run(['list'])
    cli.run(['rm'])
    cli.run(['rm', 'foo'])
    cli.run(['rm', 'foo.bar'])
    cli.run(['list'])
  })

  it('version', function() {
    cli.run(['--version'])
    cli.run(['-v'])
  })

  it('help', function() {
    cli.run(['help'])
  })
})