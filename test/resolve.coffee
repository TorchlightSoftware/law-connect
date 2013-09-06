should = require 'should'
law = require 'law'

resolve = require '../lib/resolve'

{inspect} = require './util'


routeDefs = require '../sample/routes'
serviceDefs = require '../sample/services'
services = law.process serviceDefs


expected =
  'indexThings':
    err: null
    result:
      data: 'indexThings'
  'showThing':
    err: null
    result:
      data: 'showThing'
  'createThing':
    err: null
    result:
      data: 'createThing'
  'updateThing':
    err: null
    result:
      data: 'updateThing'
  'nothing':
    err: new Error '501 Not Implemented'
    result: {}


describe 'resolve', () ->
  beforeEach (done) ->
    @resolved = resolve services, routeDefs
    should.exist @resolved, '@resolved should exist'
    done()

  for i,r of routeDefs
    do (i, r) ->
      description = "should resolve #{r.serviceName} iff it exists"

      it description, (done) ->
        should.exist @resolved[i]
        {serviceName} = @resolved[i]
        should.exist serviceName
        should.exist @resolved[i].service

        @resolved[i].service {}, (err, result) ->
          should.equal err?.message, expected[serviceName]?.err?.message
          should.equal result.data, expected[serviceName]?.result.data

        done()
