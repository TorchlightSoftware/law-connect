should = require 'should'
restler = require 'restler'

setup = require './setup'


describe 'with no services or routes wired up', () ->
  beforeEach (done) ->
    {@app, @server, @url} = setup()
    done()

  afterEach (done) ->
    @server.close()
    done()

  it 'should return with a 501 status', (done) ->
    req = restler.get @url
    should.exist req

    req.on 'complete', (result, response) ->
      should.exist result, 'expected result to exist'
      should.exist response, 'expected response to exist'
      should.exist response.statusCode, 'expected statusCode to exist'

      response.statusCode.should.equal 501

      done()
