const Router = require('routes')
const _ = require('lodash')
const fclone = require('fclone')

const { errors } = require('law')

const resolve = require('./resolve')
const makeRouter = require('./makeRouter')
const makeResource = require('./makeResource')
const errorMap = require('./errorMap')
const getResponseBody = require('./getResponseBody')

// Given a collection of route defs with resolved law services
// and a request object, return an object containing the service,
// and the HTTP request-extracted arguments we wish to pass to it.
//   services :: already-initialized law services
//   routeDefs :: config object for RESTful routing
let makeAdapter = function({services, routeDefs, options}) {

  let expandedDefs = _.flatten((_.map(routeDefs, makeResource)))
  let resolved = resolve(services, expandedDefs)
  let router = makeRouter(resolved)

  // Given a request:
  //   1. find the first matching route
  //   2. extract the path arguments and
  //   3. return the corresponding Law service (if any)
  let match = function(req) {
    let method = req.method.toLowerCase()
    let { pathname } = req._parsedUrl

    let found = router.match(pathname)

    return {
      service: (found != null ? found.fn[method] : undefined),
      pathArgs: (found != null ? found.params : undefined)
    }
  }

  // Return a piece of connect middleware
  return function(req, res, next) {

    let {service, pathArgs} = match(req)

    // This assumes that connect.json(), connect.urlencoded(), etc. have been applied
    // earlier in the middleware chain.
    let {body, query, cookies} = req
    let args = _.merge({}, pathArgs, query, cookies, body)

    // pass it on if we don't have a service for this route
    if (service == null) { return next() }

    return service(args, function(err, result) {
      let responseBody, statusCode
      if (err instanceof errors.LawError) {
        // The error is an instance of LawError, so we try to
        // map it to specially-defined handling.
        ({responseBody, statusCode} = errorMap(err))
        result = responseBody

      } else if (err instanceof Error) {
        responseBody = getResponseBody(err, result, options)

        // default, generic error handling
        if (err.message === '501 Not Implemented') {
          statusCode = 501
          responseBody = {}
        } else {
          statusCode = responseBody.statusCode || 500
        }
        // responseBody = getResponseBody err, result, options
        // responseBody =
        //   reason: err.message
        //   serviceName: service.serviceName
      } else {
        // All okay, but we need to add special
        // checks for explicit status codes &c.
        responseBody = fclone(result)

        // We don't want to include the statusCode
        // as part of the response body.
        delete responseBody.statusCode

        statusCode = result.statusCode || 200
      }

      let contentType = 'application/json'

      res.writeHead(statusCode, contentType)
      return res.end((JSON.stringify(responseBody)))
    })
  }
}

module.exports = makeAdapter
