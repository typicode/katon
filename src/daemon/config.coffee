path = require 'path'

module.exports =
  nodemonPath: path.resolve "#{__dirname}/../../node_modules/.bin/nodemon"
  staticPath: path.resolve "#{__dirname}/../../node_modules/.bin/static"