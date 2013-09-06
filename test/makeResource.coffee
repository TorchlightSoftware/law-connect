should = require 'should'
_ = require 'lodash'

{inspect} = require './util'
makeResource = require '../lib/makeResource'


testData = [
  {
    description: 'have sane defaults'
    routeDef:
      resource:
        name: 'photos'
        instance: 'photo'
    expected: [
      {
        path: '/photos'
        method: 'get'
        serviceName: 'indexPhotos'
      }
      {
        path: '/photos/new'
        method: 'get'
        serviceName: 'newPhoto'
      }
      {
        path: '/photos'
        method: 'post'
        serviceName: 'createPhoto'
      }
      {
        path: '/photos/:id'
        method: 'get'
        serviceName: 'showPhoto'
      }
      {
        path: '/photos/:id/edit'
        method: 'get'
        serviceName: 'editPhoto'
      }
      {
        path: '/photos/:id'
        method: 'patch'
        serviceName: 'updatePhoto'
      }
      {
        path: '/photos/:id'
        method: 'put'
        serviceName: 'updatePhoto'
      }
      {
        path: '/photos/:id'
        method: 'delete'
        serviceName: 'deletePhoto'
      }
    ]
  }
  {
    description: 'let you change the `id` key'
    routeDef:
      resource:
        name: 'photos'
        instance: 'photo'
        idKey: 'ident'
    expected: [
      {
        path: '/photos'
        method: 'get'
        serviceName: 'indexPhotos'
      }
      {
        path: '/photos/new'
        method: 'get'
        serviceName: 'newPhoto'
      }
      {
        path: '/photos'
        method: 'post'
        serviceName: 'createPhoto'
      }
      {
        path: '/photos/:ident'
        method: 'get'
        serviceName: 'showPhoto'
      }
      {
        path: '/photos/:ident/edit'
        method: 'get'
        serviceName: 'editPhoto'
      }
      {
        path: '/photos/:ident'
        method: 'patch'
        serviceName: 'updatePhoto'
      }
      {
        path: '/photos/:ident'
        method: 'put'
        serviceName: 'updatePhoto'
      }
      {
        path: '/photos/:ident'
        method: 'delete'
        serviceName: 'deletePhoto'
      }
    ]
  }
  {
    description: 'let you specify all path values'
    routeDef:
      resource:
        collection: 'photographs'
        instance: 'photograph'
        pathPrefix: 'api'
    expected: [
      {
        path: '/api/photographs'
        method: 'get'
        serviceName: 'indexPhotographs'
      }
      {
        path: '/api/photographs/new'
        method: 'get'
        serviceName: 'newPhotograph'
      }
      {
        path: '/api/photographs'
        method: 'post'
        serviceName: 'createPhotograph'
      }
      {
        path: '/api/photographs/:id'
        method: 'get'
        serviceName: 'showPhotograph'
      }
      {
        path: '/api/photographs/:id/edit'
        method: 'get'
        serviceName: 'editPhotograph'
      }
      {
        path: '/api/photographs/:id'
        method: 'patch'
        serviceName: 'updatePhotograph'
      }
      {
        path: '/api/photographs/:id'
        method: 'put'
        serviceName: 'updatePhotograph'
      }
      {
        path: '/api/photographs/:id'
        method: 'delete'
        serviceName: 'deletePhotograph'
      }
    ]
  }
]


describe 'resource generation', () ->
  beforeEach (done) ->
    done()

  for test in testData
    do (test) ->
      {routeDef, description, expected} = test

      it "should #{description}", (done) ->
        routeDefs = makeResource routeDef
        (_.isEqual routeDefs, expected).should.be.true

        done()
