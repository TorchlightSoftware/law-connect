should = require 'should'

{inspect} = require './util'
setup = require './setup'

resolve = require '../lib/resolve'
makeRouter = require '../lib/makeRouter'


routeDefs = require '../sample/routes'
services = require '../sample/services'


describe 'makeRouter(...).match', () ->
  beforeEach (done) ->
    @resolved = resolve services, routeDefs
    should.exist @resolved

    @router = makeRouter @resolved
    should.exist @router

    done()

  for i, r of routeDefs
    do (i, r) ->
      reqDesc = "#{r.method.toUpperCase()} #{r.path}"
      description = "expect #{reqDesc} --> #{r.serviceName}"

      it description, (done) ->

        match = @router.match r.path
        should.exist match

        service = match.fn?[r.method]
        should.exist service
        should.exist service.serviceName

        service.serviceName.should.equal  r.serviceName
        should.exist @resolved[i].service

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
