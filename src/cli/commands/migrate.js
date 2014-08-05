var fs    = require('fs')
var path  = require('path')
var chalk = require('chalk')
var add   = require('./add')

module.exports = function() {
  console.log('Migration script to katon 0.5.x')

  fs.readdirSync(process.env.HOME + '/.katon').forEach(function(name) {
    var filename       = process.env.HOME + '/.katon/' + name
    var isSymbolicLink = fs.lstatSync(filename).isSymbolicLink()

    if (isSymbolicLink) {
      var dir = path.resolve(fs.readlinkSync(filename))

      try {
        console.log(chalk.grey('\nMigrate path: ' + dir))
        var dotKatonPath = dir + '/.katon'
        var command = fs.existsSync(dotKatonPath)
          ? (fs.readFileSync(dotKatonPath, 'utf-8').trim())
          : 'npm start'
        
        console.log(chalk.grey('Add path: ' + dir + ' command: ' + command))
        add(command, dir)
        fs.unlinkSync(dotKatonPath)
      } catch(e) {
        console.log(chalk.red('Failed to migrate ' + dir + '\n' + e))  
      }
      
      fs.unlinkSync(filename)
    }
  })

  console.log('\nDone, run `katon list` to verify')
}