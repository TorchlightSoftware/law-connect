url = require 'url'

law = require 'law'
should = require 'should'
request = require 'request'
_ = require 'lodash'

setup = require './setup'

# test services
serviceDefs =
  'hello':
    service: (args, done) ->
      done null, {greeting: 'hello, world'}

  'echo':
    service: (args, done) ->
      done null, {echoed: args}

  'greet':
    service: (args, done) ->
      {name} = args
      greeting = "greetings, #{name}"
      done null, {greeting}

  'createSomething':
    service: (args, done) ->
      {toCreate} = args
      done null, {statusCode: 201, created: toCreate}

  'returnNonLawError':
    service: (args, done) ->
      err = new Error 'this is not a Law error'
      done err

services = law.applyMiddleware serviceDefs

# test routes and response values
routes = [
  {
    serviceName: 'hello'
    method: 'get'
    path: '/hello'
    expected:
      body: {greeting: 'hello, world'}
      statusCode: 200
  }
  {
    serviceName: 'echo'
    method: 'post'
    path: '/echo'
    data:
      x: 2
      y: 3
    expected:
      body:
        echoed:
          x: 2
          y: 3
      statusCode: 200
  }
  {
    serviceName: 'greet'
    method: 'get'
    path: '/greet/:name'
    reqPath: '/greet/everyone'
    data: {}
    expected:
      body:
        greeting: "greetings, everyone"
      statusCode: 200
  }
  {
    serviceName: 'createSomething'
    method: 'post'
    path: '/createSomething'
    data:
      toCreate:
        x: 2
        y: 3
      statusCode: 201
    expected:
      body:
        created:
          x: 2
          y: 3
      statusCode: 201
  }
  {
    serviceName: 'returnNonLawError'
    method: 'get'
    path: '/nonLawError'
    data: {}
    expected:
      body:
        message: 'this is not a Law error',
        # serviceName: 'returnNonLawError'
      statusCode: 500
  }
]


describe 'with simple services wired to routes', () ->
  beforeEach (done) ->
    options =
      includeStack: false
    {@app, @server, @url} = setup services, routes, {}, options
    done()

  afterEach (done) ->
    @server.close()
    done()

  for r in routes
    do (r) ->
      defaultDescription = "it should return expected values " +
                           "for #{r.method.toUpperCase()} #{r.path}"
      description = r.description or defaultDescription

      it description, (done) ->
        path = r.reqPath or r.path

        options =
          url: url.resolve @url, path
          method: r.method
          # We need `or true` in case there is no data
          # to ensure that the body is parsed as JSON.
          json: r.data or true

        request options, (err, resp, body) ->
          should.not.exist err
          should.exist resp
          should.exist body

          should.exist resp.statusCode
          resp.statusCode.should.equal r.expected.statusCode

          (_.isEqual body, r.expected.body).should.be.true

          done()

  after (done) ->
    done()