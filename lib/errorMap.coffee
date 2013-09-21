errors = require 'law'


defaultHandler = (err) ->
  {serviceName, message} = err
  errorName = err.name

  return {
    statusCode: 500
    responseBody: {
      errorName
      message
      serviceName
    }
  }

# Map a LawError subtype name to a handler, which should
# accept an 'err' instance and return an object of the form:
#   {
#     statusCode :: integer (HTTP status code)
#     responseBody :: object
#   }
errorSubtypeMap =

  # not currently used
  # 'LawError/FailedArgumentLookup':
  #   errorType: errors.FailedArgumentLookupError
  #   handler: defaultHandler

  'LawError/InvalidArgument':
    errorType: errors.InvalidArgumentError
    handler: (err) ->
      {serviceName, fieldName, requiredType, message} = err
      errorName = err.name

      return {
        statusCode: 500
        responseBody: {
          errorName
          message
          serviceName
          fieldName
          requiredType
        }
      }

  'LawError/InvalidArgumentsObject':
    errorType: errors.InvalidArgumentsObjectError
    handler: defaultHandler

  'LawError/InvalidServiceName':
    errorType: errors.InvalidServiceNameError
    handler: defaultHandler

  'LawError/MissingArgument':
    errorType: errors.MissingArgumentError
    handler: (err) ->
      {serviceName, message, fieldName} = err
      errorName = err.name

      return {
        statusCode: 500
        responseBody: {
          errorName
          message
          serviceName
          fieldName
        }
      }

  'LawError/NoFilterArray':
    errorType: errors.NoFilterArrayError
    handler: defaultHandler

  'LawError/ServiceDefinitionNoCallable':
    errorType: errors.ServiceDefinitionNoCallableError
    handler: defaultHandler

  'LawError/ServiceDefinitionType':
    errorType: errors.ServiceDefinitionTypeError
    handler: defaultHandler

  'LawError/ServiceReturnType':
    errorType: errors.ServiceReturnTypeError
    handler: defaultHandler

  'LawError/UnresolvableDependency':
    errorType: errors.UnresolvableDependencyError
    handler: (err) ->
      {serviceName, message, dependencyName, dependencyType} = err
      errorName = err.name

      return {
        statusCode: 500
        responseBody: {
          errorName
          message
          serviceName
          dependencyName
          dependencyType
        }
      }

  'LawError/UnresolvableDependencyType':
    errorType: errors.UnresolvableDependencyTypeError
    handler: (err) ->
      {serviceName, message, dependencyType} = err
      errorName = err.name

      return {
        statusCode: 500
        responseBody: {
          errorName
          message
          serviceName
          dependencyType
        }
      }


noHandler = (err) ->
  return {
    responseBody: {}
    statusCode: 500
  }


module.exports = (err) ->
  {handler} = errorSubtypeMap[err.name]
  handler ||= noHandler
  handler err
