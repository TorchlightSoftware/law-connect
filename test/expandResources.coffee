should = require 'should'
_ = require 'lodash'

{inspect} = require './util'
expandResources = require '../lib/expandResources'

routesWithResource = require '../sample/routesWithResource'
expected = [
  {
    path: '/something'
    method: 'get'
    serviceName: 'indexThings'
  }
  # begin expansion of resource def
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
  # end expansion of resource def
  {
    path: '/nothing'
    method: 'get'
    serviceName: 'nothing'
  }
]


describe 'in-place route generation for resources', () ->
  it 'should insert the generated routes in-place', (done) ->
    expanded = expandResources routesWithResource
    (_.isEqual expanded, expanded).should.equal true
    done()