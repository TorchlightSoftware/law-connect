should = require 'should'
request = require 'request'

setup = require './setup'

describe 'with no services or routes wired up', () ->
  beforeEach (done) ->
    options =
      includeStack: false
    {@app, @server, @url} = setup null, null, null, options
    done()

  afterEach (done) ->
    @server.close()
    done()

  it 'should return with a 404 status', (done) ->
    request.get @url, (err, resp, body) ->

      should.not.exist err
      should.exist resp
      should.exist resp.statusCode
      resp.statusCode.should.equal 404

      done()
