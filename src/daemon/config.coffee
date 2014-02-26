path = require 'path'

module.exports =
  nvmPath: "#{process.env.HOME}/.nvm"
  nodemonPath: path.resolve "#{__dirname}/../../node_modules/.bin/nodemon"
  staticPath: path.resolve "#{__dirname}/../../node_modules/.bin/static"