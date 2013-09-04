Router = require 'routes'
_ = require 'lodash'

noService = require './noService'

# Given a collection of route defs with resolved law services
# and a request object, return an object containing the service,
# and the HTTP request-extracted arguments we wish to pass to it.
makeRouter = require './makeRouter'

makeMatch = (routes) ->
  router = makeRouter routes

  match = (routes, req) ->
    method = req.method.toLowerCase()
    pathname = req._parsedUrl.pathname

    found = router.match pathname
    service = found?[method]

    # for r in routes
    #   methodMatch = (r.method == method)
    #   pathMatch = (r.path == pathname)
    #   if methodMatch and pathMatch
    #     {service} = r.service

    service = service || noService

    return service

# services :: already-initialized law services
# routeDefs :: config object for RESTful routing
makeAdapter = (services, routeDefs) ->




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
      toSend = JSON.stringify result
      res.end (JSON.stringify result)


module.exports = makeAdapter
