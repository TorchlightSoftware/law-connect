noService = require './noService'

# Resolve service names in route definitions.
# Default function returns with '501 Not Implemented' if the
# `routesDefs` config structure has any unresolvable service refs,
# relative to the initialized `services` object.
resolve = (services, routeDefs) ->
  attachService = (def) ->
    foundService = services[def.serviceName]
    def.service = foundService or noService

  routeDefs.forEach attachService
  return routeDefs

module.exports = resolve