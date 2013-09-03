noService = require './noService'

# Resolve service names in route definitions.
# Default function returns with '501 Not Implemented' if the
# `routesDefs` config structure has any unresolvable service refs,
# relative to the initialized `services` object.
resolveDef = (services) ->
  (def) ->
    {serviceName} = def
    foundService = services[serviceName]
    def.service = foundService || noService
    return def

resolve = (routeDefs, services) ->
  resolved = routeDefs.map (resolveDef services)

module.exports = resolve