var path = require('path')

// Convert a path to a host name
// Ex: /path/my_app -> my-app
module.exports = function(dir) {
  return path.basename(dir).replace(/_/g, '-')
}