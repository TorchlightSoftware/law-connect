const should = require('should')
const _ = require('lodash')

const makeResource = require('../lib/makeResource')

const testData = [
  {
    description: 'have sane defaults',
    routeDef: {
      resource: 'photos'
    },
    expected: [
      {
        path: '/photos',
        method: 'get',
        serviceName: 'photos/index'
      },
      {
        path: '/photos/new',
        method: 'get',
        serviceName: 'photos/new'
      },
      {
        path: '/photos',
        method: 'post',
        serviceName: 'photos/create'
      },
      {
        path: '/photos/:id',
        method: 'get',
        serviceName: 'photos/show'
      },
      {
        path: '/photos/:id/edit',
        method: 'get',
        serviceName: 'photos/edit'
      },
      {
        path: '/photos/:id',
        method: 'patch',
        serviceName: 'photos/update'
      },
      {
        path: '/photos/:id',
        method: 'put',
        serviceName: 'photos/update'
      },
      {
        path: '/photos/:id',
        method: 'delete',
        serviceName: 'photos/delete'
      }
    ]
  },
  {
    description: 'let you change the `id` key',
    routeDef: {
      resource: 'photos',
      id: 'ident'
    },
    expected: [
      {
        path: '/photos',
        method: 'get',
        serviceName: 'photos/index'
      },
      {
        path: '/photos/new',
        method: 'get',
        serviceName: 'photos/new'
      },
      {
        path: '/photos',
        method: 'post',
        serviceName: 'photos/create'
      },
      {
        path: '/photos/:ident',
        method: 'get',
        serviceName: 'photos/show'
      },
      {
        path: '/photos/:ident/edit',
        method: 'get',
        serviceName: 'photos/edit'
      },
      {
        path: '/photos/:ident',
        method: 'patch',
        serviceName: 'photos/update'
      },
      {
        path: '/photos/:ident',
        method: 'put',
        serviceName: 'photos/update'
      },
      {
        path: '/photos/:ident',
        method: 'delete',
        serviceName: 'photos/delete'
      }
    ]
  },
  {
    description: 'let you specify all path values',
    routeDef: {
      resource: 'photographs',
      prefix: 'api'
    },
    expected: [
      {
        path: '/api/photographs',
        method: 'get',
        serviceName: 'photographs/index'
      },
      {
        path: '/api/photographs/new',
        method: 'get',
        serviceName: 'photographs/new'
      },
      {
        path: '/api/photographs',
        method: 'post',
        serviceName: 'photographs/create'
      },
      {
        path: '/api/photographs/:id',
        method: 'get',
        serviceName: 'photographs/show'
      },
      {
        path: '/api/photographs/:id/edit',
        method: 'get',
        serviceName: 'photographs/edit'
      },
      {
        path: '/api/photographs/:id',
        method: 'patch',
        serviceName: 'photographs/update'
      },
      {
        path: '/api/photographs/:id',
        method: 'put',
        serviceName: 'photographs/update'
      },
      {
        path: '/api/photographs/:id',
        method: 'delete',
        serviceName: 'photographs/delete'
      }
    ]
  }
]

describe('resource generation', function() {
  beforeEach(done => done())

  return Array.from(testData).map((test) =>
    (function(test) {
      const {routeDef, description, expected} = test

      return it(`should ${description}`, function(done) {
        const routeDefs = makeResource(routeDef)
        routeDefs.should.eql(expected)

        return done()
      })
    })(test))
})
