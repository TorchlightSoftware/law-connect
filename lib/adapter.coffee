Router = require 'routes'
_ = require 'lodash'

{errors} = require 'law'

noService = require './noService'
resolve = require './resolve'
makeRouter = require './makeRouter'
makeResource = require './makeResource'
errorMap = require './errorMap'
getResponseBody = require './getResponseBody'

# Given a collection of route defs with resolved law services
# and a request object, return an object containing the service,
# and the HTTP request-extracted arguments we wish to pass to it.
#   services :: already-initialized law services
#   routeDefs :: config object for RESTful routing
makeAdapter = ({services, routeDefs, options}) ->

  expandedDefs = _.flatten (_.map routeDefs, makeResource)
  resolved = resolve services, expandedDefs
  router = makeRouter resolved

  # Given a request:
  #   1. find the first matching route
  #   2. extract the path arguments and
  #   3. return the corresponding Law service (if any)
  match = (req) ->
    method = req.method.toLowerCase()
    pathname = req._parsedUrl.pathname

    found = router.match pathname

    return {
      service: found?.fn[method]
      pathArgs: found?.params
    }

  # Return a piece of connect middleware
  (req, res, next) ->

    {service, pathArgs} = match req

    # This assumes that connect.bodyParser has been applied
    # earlier in the middleware chain.
    {body, query, cookies} = req
    args = _.merge {}, pathArgs, query, cookies, body

    # pass it on if we don't have a service for this route
    return next() unless service?

    service args, (err, result) ->
      if (err instanceof errors.LawError)
        # The error is an instance of LawError, so we try to
        # map it to specially-defined handling.
        {responseBody, statusCode} = errorMap err
        result = responseBody

      else if (err instanceof Error)
        responseBody = getResponseBody err, result, options

        # default, generic error handling
        if err.message == '501 Not Implemented'
          statusCode = 501
          responseBody = {}
        else
          statusCode = 500
        # responseBody = getResponseBody err, result, options
        # responseBody =
        #   reason: err.message
        #   serviceName: service.serviceName
      else
        # All okay, but we need to add special
        # checks for explicit status codes &c.
        responseBody = _.cloneDeep result

        # We don't want to include the statusCode
        # as part of the response body.
        delete responseBody.statusCode

        statusCode = result.statusCode or 200

      contentType = 'application/json'

      res.writeHead statusCode, contentType
      res.end (JSON.stringify responseBody)


module.exports = makeAdapter
