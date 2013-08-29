_ = require 'lodash'

noService = (args, done) ->
  # https://tools.ietf.org/html/rfc2616#section-10.5.2
  done (new Error '501 Not Implemented'), {}


# Transform a connect.request object into an abstracted
# reqInfo metadata structure.
getReqInfo = (req) ->
  path = req._parsedUrl.pathname
  reqInfo =
    url: req.url
    headers: req.headers || {}
    query: req.query || {}
    cookies: req.cookies || {}
    path: path
    pathParts: path.split '/'
  return reqInfo


# Given a collection of route defs with resolved law services
# and a request object, return an object containing the service,
# and the HTTP request-extracted arguments we wish to pass to it.
match = (routes, req) ->
  method = req.method.toLowerCase()
  pathname = req._parsedUrl.pathname

  for r in routes
    methodMatch = (r.method == method)
    pathMatch = (r.path == pathname)
    if methodMatch and pathMatch
      {service} = r.service

  service = service || noService

  return service

# services :: already-initialized law services
# routeDefs :: config object for RESTful routing
makeAdapter = (services, routeDefs) ->

  # Resolve service names in route definitions.
  # Default function returns with 501 Not Implemented if the
  # `routes` config structure has any empty service refs, relative
  # to the initialized services object.
  routes = []
  for def in routeDefs
    do (def) ->
      {serviceName} = def

      foundService = services[serviceName]
      def.service = foundService || noService
      routes.push def

  # Return a piece of connect middleware
  (req, res) ->

    # This assumes that connect.bodyParser has been applied
    # earlier in the middleware chain.
    {body, query, cookies} = req
    args = _.merge {}, query, cookies, body
    service = match routes, req

    service args, (err, result) ->
      switch err?.message
        when '501 Not Implemented'
          statusCode = 501
        else
          if err?
            statusCode = 500
          else
            statusCode = 200

      contentType = 'application/json'

      res.writeHead statusCode, contentType

      res.end()


module.exports = makeAdapter
