_ = require 'lodash'
Router = require 'routes'

# Makes a Router instance that can be used to match a
# path to with a map of the form:
#   HTTPMethod -> LawService
makeRouter = (routes) ->
  # Group list of routes by path, so our dispatching can
  # be secondarily based on HTTP method.
  grouped = _.groupBy routes, (r) -> r.path

  # Transform one array of routes into an object
  # mapping HTTP method to a Law service.
  transform = (result, pathRoutes, path) ->
    methodMap = {}
    for r in pathRoutes
      methodMap[r.method] = r.service
      methodMap[r.method].serviceName = r.serviceName
    result[path] = methodMap

  # Actually transform the grouped routes
  transformed = _.transform grouped, transform

  # Set the HTTP method mappings to be the matches
  # for their parent URL paths.
  router = Router()
  for r in routes
    router.addRoute r.path, transformed[r.path]

  return router


module.exports = makeRouter