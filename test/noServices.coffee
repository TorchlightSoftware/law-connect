should = require 'should'
request = require 'request'

setup = require './setup'


describe 'with no services or routes wired up', () ->
  beforeEach (done) ->
    {@app, @server, @url} = setup()
    done()

  afterEach (done) ->
    @server.close()
    done()

  it 'should return with a 501 status', (done) ->
    request.get @url, (err, resp, body) ->

      should.not.exist err
      should.exist resp
      should.exist resp.statusCode
      resp.statusCode.should.equal 501

      done()
