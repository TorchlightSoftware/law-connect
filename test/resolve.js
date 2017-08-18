const should = require('should')
const law = require('law')
const _ = require('lodash')

const resolve = require('../lib/resolve')
const routeDefs = require('../sample/routes')
const serviceDefs = require('../sample/services')

const services = law.applyMiddleware(serviceDefs)


const expected = {
  'indexThings': {
    err: null,
    result: {
      data: 'indexThings'
    }
  },
  'showThing': {
    err: null,
    result: {
      data: 'showThing'
    }
  },
  'createThing': {
    err: null,
    result: {
      data: 'createThing'
    }
  },
  'updateThing': {
    err: null,
    result: {
      data: 'updateThing'
    }
  },
  'nothing': {
    err: new Error('501 Not Implemented'),
    result: {}
  }
}


describe('resolve', function() {
  beforeEach(function(done) {
    this.resolved = resolve(services, routeDefs)
    should.exist(this.resolved, '@resolved should exist')
    return done()
  })

  routeDefs.forEach((r, i) => {
    if (r.serviceName !== 'nothing') {
      const description = `should resolve ${r.serviceName} iff it exists`

      it(description, function(done) {
        should.exist(this.resolved[i])
        const {serviceName} = this.resolved[i]
        should.exist(serviceName)
        should.exist(this.resolved[i].service, `expected ${r.serviceName} to be resolved`)

        this.resolved[i].service({}, function(err, result) {
          should.equal(err != null ? err.message : undefined, __guard__(expected[serviceName] != null ? expected[serviceName].err : undefined, x => x.message))
          return should.equal(result.data, expected[serviceName] != null ? expected[serviceName].result.data : undefined)
        })

        done()
      })
    }
  })

  return it('should not resolve a non-existant service', function(done) {
    const nothing = _.find(this.resolved, r => r.serviceName === 'nothing')
    should.not.exist(nothing.service)
    return done()
  })
})

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined
}
