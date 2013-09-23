_ = require 'lodash'

module.exports = (err, result, options) ->
  # By default, set all inclusion flags to 'true'
  includeDetails = includeStack = includeMessage = true

  # For each defined flag, override the default flag value ('true')
  if options.includeDetails?
    includeDetails = options.includeDetails

  if options.includeMessage?
    includeMessage = options.includeMessage

  if options.includeStack?
    includeStack = options.includeStack

  # Set up the response value
  body = {}

  # do we want to merge the result in on error?
  # _.merge body, result

  # Build the 'body' object as indicated by the
  # values of the inclusion flags.
  if includeMessage
    body.message = err.message

  if includeStack
    body.stack = err.stack

  if includeDetails
    details = _.clone err.valueOf()
    delete details.message
    body = _.merge body, details

  return body
