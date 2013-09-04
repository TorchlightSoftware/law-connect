Router = require 'routes'
_ = require 'lodash'

noService = require './noService'
resolve = require './resolve'
makeRouter = require './makeRouter'
expandResources = require './expandResources'


# Given a collection of route defs with resolved law services
# and a request object, return an object containing the service,
# and the HTTP request-extracted arguments we wish to pass to it.
#   services :: already-initialized law services
#   routeDefs :: config object for RESTful routing
makeAdapter = (services, routeDefs) ->

  expandedDefs = expandResources routeDefs
  resolved = resolve services, expandedDefs

  match = (req) ->
    method = req.method.toLowerCase()
    pathname = req._parsedUrl.pathname

    router = makeRouter resolved
    found = router.match pathname

    return {
      service: found?.fn[method] || noService
      pathArgs: found?.params
    }

  # Return a piece of connect middleware
  (req, res) ->

    {service, pathArgs} = match req

    # This assumes that connect.bodyParser has been applied
    # earlier in the middleware chain.
    {body, query, cookies} = req
    args = _.merge {}, pathArgs, query, cookies, body

    service args, (err, result) ->
      switch err?.message
        when '501 Not Implemented'
          statusCode = 501
        else
          if err?
            console.log {err}
            statusCode = 500
          else
            statusCode = 200

      contentType = 'application/json'

      res.writeHead statusCode, contentType
      toSend = JSON.stringify result
      res.end (JSON.stringify result)


module.exports = makeAdapter
