url = require 'url'

should = require 'should'
request = require 'request'
_ = require 'lodash'

setup = require './setup'

# test services
services =
  'hello':
    serviceName: 'hello'
    service: (args, done) ->
      done null, {greeting: 'hello, world'}

  'echo':
    serviceName: 'echo'
    service: (args, done) ->
      done null, {echoed: args}


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

        options =
          url: url.resolve @url, r.path
          method: r.method
          # We need `|| true` in case there is no data
          # to ensure that the body is parsed as JSON.
          json: r.data || true

        request options, (err, resp, body) ->
          should.not.exist err
          should.exist resp
          should.exist body

          should.exist resp.statusCode
          resp.statusCode.should.equal r.expected.statusCode

          (_.isEqual body, r.expected.body).should.be.true

          done()
