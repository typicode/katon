var timeouts = {}

module.exports = function(id, fn) {
  clearTimeout(timeouts[id])
  timeouts[id] = setTimeout(fn, 60 * 60 * 1000)
}