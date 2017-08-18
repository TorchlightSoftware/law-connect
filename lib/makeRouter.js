const _ = require('lodash')
const Router = require('routes')

// Makes a Router instance that can be used to match a
// path to with a map of the form:
//   HTTPMethod -> LawService
let makeRouter = function(routes) {
  // Group list of routes by path, so our dispatching can
  // be secondarily based on HTTP method.
  let grouped = _.groupBy(routes, r => r.path)

  // Transform one array of routes into an object
  // mapping HTTP method to a Law service.
  let transform = function(result, pathRoutes, path) {
    let methodMap = {}
    for (let r of Array.from(pathRoutes)) {
      if (r.service != null) {
        methodMap[r.method] = r.service
        methodMap[r.method].serviceName = r.serviceName
      }
    }

    return result[path] = methodMap
  }

  // Actually transform the grouped routes
  let transformed = _.transform(grouped, transform)

  // Set the HTTP method mappings to be the matches
  // for their parent URL paths.
  let router = Router()
  for (let r of Array.from(routes)) {
    router.addRoute(r.path, transformed[r.path])
  }

  return router
}

module.exports = makeRouter
