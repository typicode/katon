fs  = require 'fs'
eco = require 'eco'

module.exports = (file, context) ->
  tpl = fs.readFileSync "#{__dirname}/../templates/#{file}", 'utf-8'
  eco.render tpl, context