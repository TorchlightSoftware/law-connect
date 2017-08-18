const errors = require('law')

let defaultHandler = function(err) {
  let {serviceName, message} = err
  let errorName = err.name

  return {
    statusCode: 500,
    responseBody: {
      errorName,
      message,
      serviceName
    }
  }
}

// Map a LawError subtype name to a handler, which should
// accept an 'err' instance and return an object of the form:
//   {
//     statusCode :: integer (HTTP status code)
//     responseBody :: object
//   }
let errorSubtypeMap = {

  // not currently used
  // 'LawError/FailedArgumentLookup':
  //   errorType: errors.FailedArgumentLookupError
  //   handler: defaultHandler

  'LawError/InvalidArgument': {
    errorType: errors.InvalidArgumentError,
    handler(err) {
      let {serviceName, fieldName, requiredType, message} = err
      let errorName = err.name

      return {
        statusCode: 500,
        responseBody: {
          errorName,
          message,
          serviceName,
          fieldName,
          requiredType
        }
      }
    }
  },

  'LawError/InvalidArgumentsObject': {
    errorType: errors.InvalidArgumentsObjectError,
    handler: defaultHandler
  },

  'LawError/InvalidServiceName': {
    errorType: errors.InvalidServiceNameError,
    handler: defaultHandler
  },

  'LawError/MissingArgument': {
    errorType: errors.MissingArgumentError,
    handler(err) {
      let {serviceName, message, fieldName} = err
      let errorName = err.name

      return {
        statusCode: 500,
        responseBody: {
          errorName,
          message,
          serviceName,
          fieldName
        }
      }
    }
  },

  'LawError/NoFilterArray': {
    errorType: errors.NoFilterArrayError,
    handler: defaultHandler
  },

  'LawError/ServiceDefinitionNoCallable': {
    errorType: errors.ServiceDefinitionNoCallableError,
    handler: defaultHandler
  },

  'LawError/ServiceDefinitionType': {
    errorType: errors.ServiceDefinitionTypeError,
    handler: defaultHandler
  },

  'LawError/ServiceReturnType': {
    errorType: errors.ServiceReturnTypeError,
    handler: defaultHandler
  },

  'LawError/UnresolvableDependency': {
    errorType: errors.UnresolvableDependencyError,
    handler(err) {
      let {serviceName, message, dependencyName, dependencyType} = err
      let errorName = err.name

      return {
        statusCode: 500,
        responseBody: {
          errorName,
          message,
          serviceName,
          dependencyName,
          dependencyType
        }
      }
    }
  },

  'LawError/UnresolvableDependencyType': {
    errorType: errors.UnresolvableDependencyTypeError,
    handler(err) {
      let {serviceName, message, dependencyType} = err
      let errorName = err.name

      return {
        statusCode: 500,
        responseBody: {
          errorName,
          message,
          serviceName,
          dependencyType
        }
      }
    }
  }
}

let noHandler = err => ({
  responseBody: {},
  statusCode: 500
})

module.exports = function(err) {
  let {handler} = errorSubtypeMap[err.name]
  if (!handler) { handler = noHandler }
  return handler(err)
}
