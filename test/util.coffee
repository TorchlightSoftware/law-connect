util = require 'util'

inspect = (o) ->
  s = util.inspect o, {
    colors: true
    depth: 8
  }
  console.log s

module.exports = { inspect }
