law = require 'law'
should = require 'should'
_ = require 'lodash'

{inspect} = require './util'
setup = require './setup'

resolve = require '../lib/resolve'
makeRouter = require '../lib/makeRouter'


routeDefs = require '../sample/routes'
serviceDefs = require '../sample/services'
services = law.applyMiddleware serviceDefs


describe 'makeRouter(...).match', () ->
  beforeEach (done) ->
    @resolved = resolve services, routeDefs
    should.exist @resolved, 'expected services to resolve'

    @router = makeRouter @resolved
    should.exist @router, 'expected router to be created'

    done()

  for r, i in routeDefs when r.serviceName isnt 'nothing'
    do (i, r) ->
      reqDesc = "#{r.method.toUpperCase()} #{r.path}"
      description = "expect #{reqDesc} --> #{r.serviceName}"

      it description, (done) ->

        match = @router.match r.path
        should.exist match, "expected path #{r.path} to match a route"

        service = match.fn?[r.method]
        should.exist service, "expected #{r.method} #{r.path} to exist"
        should.exist service.serviceName, "expected #{r.method} #{r.path} to have a serviceName"

        service.serviceName.should.equal r.serviceName
        should.exist @resolved[i].service, "expected #{r.serviceName} to be resolved"

        service {}, (err, result) =>
          @resolved[i].service {}, (expectedErr, expectedResult) =>
            # inspect {
            #   actual:
            #     err: err
            #     result: result
            #   expected:
            #     err: expectedErr
            #     result: expectedResult
            # }
            should.equal err?.message, expectedErr?.message
            should.equal result?.data, expectedResult?.data

            done()

  it 'should not resolve a non-existant service', (done) ->
    match = @router.match r.path
    should.exist match, "expected path #{r.path} to match a route"

    service = match.fn?[r.method]
    should.not.exist service, "expected #{r.method} #{r.path} to not exist"

    nothing = _.find @resolved, (r) -> r.serviceName is 'nothing'
    should.not.exist nothing.service, "expected #{r.serviceName} to not be resolved"
    done()
