url = require 'url'

should = require 'should'

law = require 'law'
{errors} = law
request = require 'request'
setup = require './setup'


# define a test service to return specific errors
serviceDefs =
  'returnError':
    service: (args, done) ->
      {errorTypeName, context} = args
      ErrorSubtype = errors[errorTypeName]
      err = new ErrorSubtype context
      done err

# wire up a hot services object
services = law.applyMiddleware serviceDefs

# define a test route to return errors
routes = [
  serviceName: 'returnError'
  method: 'post'
  path: '/returnError'
]


# default context data for the errors to throw
timestamp = Date.now()
defaultContext =
  serviceName: 'doSomething'
  fieldName: 'sessionId'
  requiredType: 'SessionId'
  dependencyName: 'helpDoSomething'
  dependencyType: 'services'
  args:
    sessionId: 'malformed'
  timestamp: timestamp

# function to construct an expected body
makeDefaultExpectedBody = ({message, errorName}) ->
  return {
    serviceName: 'doSomething'
    fieldName: 'sessionId'
    requiredType: 'SessionId'
    args:
      sessionId: 'malformed'
    timestamp: timestamp
    message: message
    errorName: errorName
  }


subtypeExpectations = [
  # # not currently used
  # {
  #   errorTypeName: 'FailedArgumentLookupError'
  #   errorType: errors.FailedArgumentLookupError
  #   context: defaultContext
  #   expected:
  #     statusCode: 500
  # }
  {
    errorTypeName: 'InvalidArgumentError'
    errorType: errors.InvalidArgumentError
    context: defaultContext
    expected:
      statusCode: 500
      body:
        errorName: 'LawError/InvalidArgument'
        message: "'doSomething' requires 'sessionId' to be a valid 'SessionId'."
        serviceName: defaultContext.serviceName
        fieldName: defaultContext.fieldName
        requiredType: defaultContext.requiredType
  }
  {
    errorTypeName: 'InvalidArgumentsObjectError'
    errorType: errors.InvalidArgumentsObjectError
    context: defaultContext
    expected:
      statusCode: 500
      body:
        errorName: 'LawError/InvalidArgumentsObject'
        message: "'doSomething' requires an arguments object as the first argument."
        serviceName: defaultContext.serviceName
  }
  {
    errorTypeName: 'InvalidServiceNameError'
    errorType: errors.InvalidServiceNameError
    context: defaultContext
    expected:
      statusCode: 500
      body:
        errorName: 'LawError/InvalidServiceName'
        message: "Error loading policy: 'doSomething' is not a valid service name."
        serviceName: defaultContext.serviceName
  }
  {
    errorTypeName: 'MissingArgumentError'
    errorType: errors.MissingArgumentError
    context: defaultContext
    expected:
      statusCode: 500
      body:
        errorName: 'LawError/MissingArgument'
        message: "'doSomething' requires 'sessionId' to be defined."
        serviceName: defaultContext.serviceName
        fieldName: defaultContext.fieldName
  }
  {
    errorTypeName: 'NoFilterArrayError'
    errorType: errors.NoFilterArrayError
    context: defaultContext
    expected:
      statusCode: 500
      body:
        errorName: 'LawError/NoFilterArray'
        message: "Error loading policy: Validations must contain array of filters."
        serviceName: defaultContext.serviceName
  }
  {
    errorTypeName: 'ServiceDefinitionNoCallableError'
    errorType: errors.ServiceDefinitionNoCallableError
    context: defaultContext
    expected:
      statusCode: 500
      body:
        errorName: 'LawError/ServiceDefinitionNoCallable'
        message: "Could not find function definition for service 'doSomething'."
        serviceName: defaultContext.serviceName
  }
  {
    errorTypeName: 'ServiceDefinitionTypeError'
    errorType: errors.ServiceDefinitionTypeError
    context: defaultContext
    expected:
      statusCode: 500
      body:
        errorName: 'LawError/ServiceDefinitionType'
        message: "Service 'doSomething' is not an object or a function."
        serviceName: defaultContext.serviceName
  }
  {
    errorTypeName: 'ServiceReturnTypeError'
    errorType: errors.ServiceReturnTypeError
    context: defaultContext
    expected:
      statusCode: 500
      body:
        errorName: 'LawError/ServiceReturnType'
        message: "'doSomething' must return an object."
        serviceName: defaultContext.serviceName
  }
  {
    errorTypeName: 'UnresolvableDependencyError'
    errorType: errors.UnresolvableDependencyError
    context: defaultContext
    expected:
      statusCode: 500
      body:
        errorName: 'LawError/UnresolvableDependency'
        message: "Loading 'doSomething': No resolution for dependency 'helpDoSomething' of type 'services'."
        serviceName: defaultContext.serviceName
        dependencyName: defaultContext.dependencyName
        dependencyType: defaultContext.dependencyType
  }
  {
    errorTypeName: 'UnresolvableDependencyTypeError'
    errorType: errors.UnresolvableDependencyTypeError
    context: defaultContext
    expected:
      statusCode: 500
      body:
        errorName: 'LawError/UnresolvableDependencyType'
        message: "Loading 'doSomething': No resolution for dependencyType 'services'."
        serviceName: defaultContext.serviceName
        dependencyType: defaultContext.dependencyType
  }
]


describe 'Error handling', ->
  beforeEach (done) ->
    {@app, @server, @url} = setup services, routes
    done()

  afterEach (done) ->
    @server.close()
    done()

  for datum in subtypeExpectations
    do (datum) ->
      {errorTypeName, context, expected} = datum
      description = "#{errorTypeName} should return what we expect"
      it description, (done) ->
        options =
          url: url.resolve @url, '/returnError'
          method: 'post'
          json: {errorTypeName, context}

        request options, (err, resp, body) ->
          # console.log 'in handler:', {err, body}
          should.not.exist err

          should.exist resp
          should.exist resp.statusCode
          resp.statusCode.should.equal expected.statusCode

          should.exist body
          body.should.eql expected.body

          done()
