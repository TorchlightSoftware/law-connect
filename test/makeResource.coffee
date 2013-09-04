should = require 'should'
_ = require 'lodash'

{inspect} = require './util'
makeResource = require '../lib/makeResource'


testData = [
  {
    description: 'have sane defaults'
    def:
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
    def:
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
]


describe 'resource generation', () ->
  beforeEach (done) ->
    done()

  for test in testData
    do (test) ->
      {def, description, expected} = test

      it "should #{description}", (done) ->
        routeDefs = makeResource def

        (_.isEqual routeDefs, expected).should.equal true

        done()
