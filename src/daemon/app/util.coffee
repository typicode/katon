fs = require 'fs'
chalk = require 'chalk'

module.exports =

  log: (str) ->
    console.log chalk.cyan('app  '), str

  error: (path, str) ->
    console.log chalk.red("app   #{path?.split('/').pop()}"), str

  append: (path, data) ->
    fs.appendFileSync path, data