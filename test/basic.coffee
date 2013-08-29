url = require 'url'

should = require 'should'
restler = require 'restler'

setup = require './setup'


# test services
services =
  'hello':
    serviceName: 'hello'
    service: ({}, done) ->
      done null, {body: 'hello'}

  'echo':
    serviceName: 'echo'
    service: ({}, done) ->
      done()


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
    path: '/'
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
    # services = {}
    # routes = {}
    {@app, @server, @url} = setup services, routes
    done()

  afterEach (done) ->
    @server.close()
    done()

  it 'should return with a 200 status', (done) ->
    req = restler.get (url.resolve @url, '/hello?x=3')
    should.exist req

    req.on 'complete', (result, response) ->
      console.log result
      should.exist result, 'expected result to exist'
      should.exist response, 'expected response to exist'
      should.exist response.statusCode, 'expected statusCode to exist'

      response.statusCode.should.equal 200

      done()
