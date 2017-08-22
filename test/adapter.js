const url = require('url')
const law = require('law')
const should = require('should')
const request = require('request')
const _ = require('lodash')

const setup = require('./setup')

const circular = {
  x: 2,
  y: 3
}
circular.moreData = circular

// test services
const serviceDefs = {
  hello: {
    service(args, done) {
      return done(null, {greeting: 'hello, world'})
    }
  },

  echo: {
    service(args, done) {
      return done(null, {echoed: args})
    }
  },

  greet: {
    service(args, done) {
      const {name} = args
      const greeting = `greetings, ${name}`
      return done(null, {greeting})
    }
  },

  createSomething: {
    service(args, done) {
      const {toCreate} = args
      return done(null, {statusCode: 201, created: toCreate})
    }
  },

  returnNonLawError: {
    service(args, done) {
      const err = new Error('this is not a Law error')
      return done(err)
    }
  }
}

const services = law.applyMiddleware(serviceDefs)

// test routes and response values
const routes = [
  {
    serviceName: 'hello',
    method: 'get',
    path: '/hello',
    expected: {
      body: {greeting: 'hello, world'},
      statusCode: 200
    }
  },
  {
    serviceName: 'echo',
    method: 'post',
    path: '/echo',
    data: {
      x: 2,
      y: 3
    },
    expected: {
      body: {
        echoed: {
          x: 2,
          y: 3
        }
      },
      statusCode: 200
    }
  },
  {
    serviceName: 'echo',
    method: 'post',
    path: '/echoCircular',
    data: circular,
    expected: {
      body: {
        echoed: {
          x: 2,
          y: 3,
          moreData: '[Circular ~]'
        }
      },
      statusCode: 200
    }
  },
  {
    serviceName: 'greet',
    method: 'get',
    path: '/greet/:name',
    reqPath: '/greet/everyone',
    data: {},
    expected: {
      body: {
        greeting: "greetings, everyone"
      },
      statusCode: 200
    }
  },
  {
    serviceName: 'createSomething',
    method: 'post',
    path: '/createSomething',
    data: {
      toCreate: {
        x: 2,
        y: 3
      },
      statusCode: 201
    },
    expected: {
      body: {
        created: {
          x: 2,
          y: 3
        }
      },
      statusCode: 201
    }
  },
  {
    serviceName: 'returnNonLawError',
    method: 'get',
    path: '/nonLawError',
    data: {},
    expected: {
      body: {
        message: 'this is not a Law error'
      },
        // serviceName: 'returnNonLawError'
      statusCode: 500
    }
  }
]


describe('adapter - with simple services wired to routes', function() {
  beforeEach(function(done) {
    const options = {includeStack: false}
    _.merge(this, setup(services, routes, {}, options))
    return done()
  })

  afterEach(function(done) {
    this.server.close()
    return done()
  })

  for (let r of Array.from(routes)) {
    (function(r) {
      const defaultDescription = "it should return expected values " + `for ${r.method.toUpperCase()} ${r.path}`
      const description = r.description || defaultDescription

      return it(description, function(done) {
        const path = r.reqPath || r.path

        const options = {
          url: url.resolve(this.url, path),
          method: r.method,
          // We need `or true` in case there is no data
          // to ensure that the body is parsed as JSON.
          json: r.data || true
        }

        return request(options, function(err, resp, body) {
          should.not.exist(err)
          should.exist(resp)
          should.exist(body)

          should.exist(resp.statusCode)
          should(resp.statusCode).equal(r.expected.statusCode)

          should(body).eql(r.expected.body)

          return done()
        })
      })
    })(r)
  }

  return after(done => done())
})
