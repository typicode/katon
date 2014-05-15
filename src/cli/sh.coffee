exec   = require('child_process').exec

module.exports = (cmd) ->
  exec cmd, (err, stdout, stderr) ->
    console.info stdout
    console.error stderr
    if err
      console.error err