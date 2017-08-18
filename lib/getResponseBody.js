const _ = require('lodash')

module.exports = function(err, result, options) {
  // By default, set all inclusion flags to 'true'
  let includeMessage, includeStack
  if (options == null) { options = {} }
  let includeDetails = (includeStack = (includeMessage = true))

  // For each defined flag, override the default flag value ('true')
  if (options.includeDetails != null) {
    ({ includeDetails } = options)
  }

  if (options.includeMessage != null) {
    ({ includeMessage } = options)
  }

  if (options.includeStack != null) {
    ({ includeStack } = options)
  }

  // Set up the response value
  let body = {}

  // do we want to merge the result in on error?
  // _.merge body, result

  // Build the 'body' object as indicated by the
  // values of the inclusion flags.
  if (includeMessage) {
    body.message = err.message
  }

  if (includeStack) {
    body.stack = err.stack
  }

  let dontCopy = ['message', 'name', 'serialize', 'toJSON', 'constructor']
  if (includeDetails) {
    let details = {}
    for (let k in err) {
      let v = err[k]
      if (!Array.from(dontCopy).includes(k)) {
        details[k] = v
      }
    }
    body = _.merge(body, details)
  }

  return body
}
