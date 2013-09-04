makeResource = require './makeResource'


expandResources = (routeDefs) ->
  expanded = routeDefs.map (def) ->
    if def.resource?
      val = makeResource def.resource
    else
      val = [def]
    return val
  flattened = [].concat expanded...


module.exports = expandResources