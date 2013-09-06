makeResource = require './makeResource'
_ = require 'lodash'


expandResources = (routeDefs) ->

  _.flatten (_.map routeDefs, makeResource)


module.exports = expandResources