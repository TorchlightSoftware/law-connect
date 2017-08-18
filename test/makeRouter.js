const law = require('law')
const should = require('should')
const _ = require('lodash')

const setup = require('./setup')
const resolve = require('../lib/resolve')
const makeRouter = require('../lib/makeRouter')
const routeDefs = require('../sample/routes')
const serviceDefs = require('../sample/services')

const services = law.applyMiddleware(serviceDefs)

describe('makeRouter(...).match', function() {
  beforeEach(function(done) {
    this.resolved = resolve(services, routeDefs)
    should.exist(this.resolved, 'expected services to resolve')

    this.router = makeRouter(this.resolved)
    should.exist(this.router, 'expected router to be created')

    return done()
  })

  routeDefs.forEach((r, i) => {
    if (r.serviceName !== 'nothing') {
      const reqDesc = `${r.method.toUpperCase()} ${r.path}`
      const description = `expect ${reqDesc} --> ${r.serviceName}`

      it(description, function(done) {

        const match = this.router.match(r.path)
        should.exist(match, `expected path ${r.path} to match a route`)

        const service = match.fn != null ? match.fn[r.method] : undefined
        should.exist(service, `expected ${r.method} ${r.path} to exist`)
        should.exist(service.serviceName, `expected ${r.method} ${r.path} to have a serviceName`)

        service.serviceName.should.equal(r.serviceName)
        should.exist(this.resolved[i].service, `expected ${r.serviceName} to be resolved`)

        return service({}, (err, result) => {
          return this.resolved[i].service({}, (expectedErr, expectedResult) => {
            should.equal(err != null ? err.message : undefined, expectedErr != null ? expectedErr.message : undefined)
            should.equal(result != null ? result.data : undefined, expectedResult != null ? expectedResult.data : undefined)

            return done()
          })
        })
      })
    }
  })

  it('should not resolve a non-existant service', function(done) {
    const r = routeDefs[routeDefs.length - 1]
    const match = this.router.match(r.path)
    should.exist(match, `expected path ${r.path} to match a route`)

    const service = match.fn != null ? match.fn[r.method] : undefined
    should.not.exist(service, `expected ${r.method} ${r.path} to not exist`)

    const nothing = _.find(this.resolved, r => r.serviceName === 'nothing')
    should.not.exist(nothing.service, `expected ${r.serviceName} to not be resolved`)
    return done()
  })
})
