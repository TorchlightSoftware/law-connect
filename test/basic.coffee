url = require 'url'

should = require 'should'
restler = require 'restler'

setup = require './setup'

# test services
services =
  'hello':
    serviceName: 'hello'
    service: ({}, done) ->
      done null, {greeting: 'hello'}

  'echo':
    serviceName: 'echo'
    service: ({}, done) ->
      done null, {}


# test routes and response values
routes = [
  {
    serviceName: 'hello'
    method: 'get'
    path: '/hello'
    expected:
      body: 'hello, world'
      statusCode: 200
  }
  {
    serviceName: 'echo'
    method: 'post'
    path: '/echo'
    postData:
      x: 2
      y: 3
    expected:
      body:
        x: 2
        y: 3
      statusCode: 200
  }
]


describe 'with simple services wired to routes', () ->
  beforeEach (done) ->
    {@app, @server, @url} = setup services, routes
    done()

  afterEach (done) ->
    @server.close()
    done()

  for r in routes
    do (r) ->
      defaultDescription = "it should return expected values " +
                           "for #{r.method.toUpperCase()} #{r.path}"
      description = r.description || defaultDescription

      it description, (done) ->
        req = restler[r.method] (url.resolve @url, r.path)
        should.exist req

        req.once 'complete', (result, response) ->
          should.exist result, 'expected result to exist'
          should.exist response, 'expected response to exist'
          should.exist response.statusCode, 'expected statusCode to exist'

          response.statusCode.should.equal r.expected.statusCode

          done()
