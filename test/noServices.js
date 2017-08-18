const should = require('should')
const request = require('request')
const _ = require('lodash')

const setup = require('./setup')

describe('with no services or routes wired up', function() {
  beforeEach(function(done) {
    _.merge(this, setup(undefined, undefined, undefined, {includeStack: false}))
    done()
  })

  afterEach(function(done) {
    this.server.close()
    done()
  })

  it('should return with a 404 status', function(done) {
    request.get(this.url, function(err, resp, body) {

      should.not.exist(err)
      should.exist(resp)
      should.exist(resp.statusCode)
      resp.statusCode.should.equal(404)

      done()
    })
  })
})
