module.exports =

  log: (str) ->
    console.log chalk.yellow('[proxy]'), str

  getDomain: (host) ->
    host.split('.').slice(-2, -1).pop()