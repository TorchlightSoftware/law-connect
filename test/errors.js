const url = require('url')
const should = require('should')
const law = require('law')
const {errors} = law
const request = require('request')
const setup = require('./setup')

// define a test service to return specific errors
const serviceDefs = {
  'returnError': {
    service(args, done) {
      const {errorTypeName, context} = args
      const ErrorSubtype = errors[errorTypeName]
      const err = new ErrorSubtype(context)
      return done(err)
    }
  }
}

// wire up a hot services object
const services = law.applyMiddleware(serviceDefs)

// define a test route to return errors
const routes = [{
  serviceName: 'returnError',
  method: 'post',
  path: '/returnError'
}
]


// default context data for the errors to throw
const timestamp = Date.now()
const defaultContext = {
  serviceName: 'doSomething',
  fieldName: 'sessionId',
  requiredType: 'SessionId',
  dependencyName: 'helpDoSomething',
  dependencyType: 'services',
  args: {
    sessionId: 'malformed'
  },
  timestamp
}

// function to construct an expected body
const makeDefaultExpectedBody = ({message, errorName}) =>
  ({
    serviceName: 'doSomething',
    fieldName: 'sessionId',
    requiredType: 'SessionId',
    args: {
      sessionId: 'malformed'
    },
    timestamp,
    message,
    errorName
  })



const subtypeExpectations = [
  // # not currently used
  // {
  //   errorTypeName: 'FailedArgumentLookupError'
  //   errorType: errors.FailedArgumentLookupError
  //   context: defaultContext
  //   expected:
  //     statusCode: 500
  // }
  {
    errorTypeName: 'InvalidArgumentError',
    errorType: errors.InvalidArgumentError,
    context: defaultContext,
    expected: {
      statusCode: 500,
      body: {
        errorName: 'LawError/InvalidArgument',
        message: "'doSomething' requires 'sessionId' to be a valid 'SessionId'.",
        serviceName: defaultContext.serviceName,
        fieldName: defaultContext.fieldName,
        requiredType: defaultContext.requiredType
      }
    }
  },
  {
    errorTypeName: 'InvalidArgumentsObjectError',
    errorType: errors.InvalidArgumentsObjectError,
    context: defaultContext,
    expected: {
      statusCode: 500,
      body: {
        errorName: 'LawError/InvalidArgumentsObject',
        message: "'doSomething' requires an arguments object as the first argument.",
        serviceName: defaultContext.serviceName
      }
    }
  },
  {
    errorTypeName: 'InvalidServiceNameError',
    errorType: errors.InvalidServiceNameError,
    context: defaultContext,
    expected: {
      statusCode: 500,
      body: {
        errorName: 'LawError/InvalidServiceName',
        message: "Error loading policy: 'doSomething' is not a valid service name.",
        serviceName: defaultContext.serviceName
      }
    }
  },
  {
    errorTypeName: 'MissingArgumentError',
    errorType: errors.MissingArgumentError,
    context: defaultContext,
    expected: {
      statusCode: 500,
      body: {
        errorName: 'LawError/MissingArgument',
        message: "'doSomething' requires 'sessionId' to be defined.",
        serviceName: defaultContext.serviceName,
        fieldName: defaultContext.fieldName
      }
    }
  },
  {
    errorTypeName: 'NoFilterArrayError',
    errorType: errors.NoFilterArrayError,
    context: defaultContext,
    expected: {
      statusCode: 500,
      body: {
        errorName: 'LawError/NoFilterArray',
        message: "Error loading policy: Validations must contain array of filters.",
        serviceName: defaultContext.serviceName
      }
    }
  },
  {
    errorTypeName: 'ServiceDefinitionNoCallableError',
    errorType: errors.ServiceDefinitionNoCallableError,
    context: defaultContext,
    expected: {
      statusCode: 500,
      body: {
        errorName: 'LawError/ServiceDefinitionNoCallable',
        message: "Could not find function definition for service 'doSomething'.",
        serviceName: defaultContext.serviceName
      }
    }
  },
  {
    errorTypeName: 'ServiceDefinitionTypeError',
    errorType: errors.ServiceDefinitionTypeError,
    context: defaultContext,
    expected: {
      statusCode: 500,
      body: {
        errorName: 'LawError/ServiceDefinitionType',
        message: "Service 'doSomething' is not an object or a function.",
        serviceName: defaultContext.serviceName
      }
    }
  },
  {
    errorTypeName: 'ServiceReturnTypeError',
    errorType: errors.ServiceReturnTypeError,
    context: defaultContext,
    expected: {
      statusCode: 500,
      body: {
        errorName: 'LawError/ServiceReturnType',
        message: "'doSomething' must return an object.",
        serviceName: defaultContext.serviceName
      }
    }
  },
  {
    errorTypeName: 'UnresolvableDependencyError',
    errorType: errors.UnresolvableDependencyError,
    context: defaultContext,
    expected: {
      statusCode: 500,
      body: {
        errorName: 'LawError/UnresolvableDependency',
        message: "Loading 'doSomething': No resolution for dependency 'helpDoSomething' of type 'services'.",
        serviceName: defaultContext.serviceName,
        dependencyName: defaultContext.dependencyName,
        dependencyType: defaultContext.dependencyType
      }
    }
  },
  {
    errorTypeName: 'UnresolvableDependencyTypeError',
    errorType: errors.UnresolvableDependencyTypeError,
    context: defaultContext,
    expected: {
      statusCode: 500,
      body: {
        errorName: 'LawError/UnresolvableDependencyType',
        message: "Loading 'doSomething': No resolution for dependencyType 'services'.",
        serviceName: defaultContext.serviceName,
        dependencyType: defaultContext.dependencyType
      }
    }
  }
]


describe('Error handling', function() {
  beforeEach(function(done) {
    ({app: this.app, server: this.server, url: this.url} = setup(services, routes))
    return done()
  })

  afterEach(function(done) {
    this.server.close()
    return done()
  })

  return Array.from(subtypeExpectations).map((datum) =>
    (function(datum) {
      const {errorTypeName, context, expected} = datum
      const description = `${errorTypeName} should return what we expect`
      return it(description, function(done) {
        const options = {
          url: url.resolve(this.url, '/returnError'),
          method: 'post',
          json: {errorTypeName, context}
        }

        return request(options, function(err, resp, body) {
          // console.log 'in handler:', {err, body}
          should.not.exist(err)

          should.exist(resp)
          should.exist(resp.statusCode)
          resp.statusCode.should.equal(expected.statusCode)

          should.exist(body)
          body.should.eql(expected.body)

          return done()
        })
      })
    })(datum))
})
