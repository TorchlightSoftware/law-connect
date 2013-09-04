_ = require 'lodash'
Router = require 'routes'


makeRouter = (routes) ->
  grouped = _.groupBy routes, (r) -> r.path

  transform = (result, pathRoutes, path) ->
    methodMap = {}
    for r in pathRoutes
      methodMap[r.method] = r.service
      methodMap[r.method].serviceName = r.serviceName
    result[path] = methodMap

  transformed = _.transform grouped, transform

  router = Router()
  for r in routes
    router.addRoute r.path, transformed[r.path]

  return router


module.exports = makeRouter