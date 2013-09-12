noService = require './noService'

# Resolve service names in route definitions.
# Default function returns with '501 Not Implemented' if the
# `routesDefs` config structure has any unresolvable service refs,
# relative to the initialized `services` object.
resolve = (services, routeDefs) ->

  # Given an array of route definitions, try to resolve the
  # `serviceName` into a callable from `services`, and attach the
  # resolved service to the route def, falling back on `noService`
  # if the route definition is valid, but no service exists with
  # the same name as `serviceName`.
  attachService = (def) ->
    foundService = services[def.serviceName]
    def.service = foundService or noService

  routeDefs.forEach attachService
  return routeDefs

module.exports = resolve