# Resolve service names in route definitions.
resolve = (services, routeDefs) ->

  # Given an array of route definitions, try to resolve the
  # `serviceName` into a callable from `services`, and attach the
  # resolved service to the route def, falling back on `noService`
  # if the route definition is valid, but no service exists with
  # the same name as `serviceName`.
  attachService = (def) ->
    foundService = services[def.serviceName]
    def.service = foundService

  routeDefs.forEach attachService
  return routeDefs

module.exports = resolve
