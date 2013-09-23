should = require 'should'
_ = require 'lodash'

{errors} = require 'law'
{LawError} = errors

getResponseBody = require '../lib/getResponseBody'


defaultProperties =
  x: 100
  y: [2,3,5]
  z: 'hello!'

defaultMessage = 'uh-oh!'

testData = [
  {
    description: 'should keep properties, stack, and message by default'
    message: defaultMessage
    properties: defaultProperties
    result: {}
    options: {}
    expectStack: true
    expectMessage: true
    expectProperties: true
  }
  {
    description: 'should keep properties, stack, and message when told to'
    message: defaultMessage
    properties: defaultProperties
    result: {}
    options:
      includeDetails: true
      includeMessage: true
      includeStack: true
    expectStack: true
    expectMessage: true
    expectProperties: true
  }
  {
    description: 'should exclude stack when told to'
    message: defaultMessage
    properties: defaultProperties
    result: {}
    options:
      includeStack: false
    expectStack: false
    expectMessage: true
    expectProperties: true
  }
  {
    description: 'should exclude message when told to'
    message: defaultMessage
    properties: defaultProperties
    result: {}
    options:
      includeMessage: false
    expectStack: true
    expectMessage: false
    expectProperties: true
    }
  {
    description: 'should exclude properties when told to'
    message: defaultMessage
    properties: defaultProperties
    result: {}
    options:
      includeDetails: false
    expectStack: true
    expectMessage: true
    expectProperties: false
  }
  {
    description: 'should exclude everything when told to'
    message: defaultMessage
    properties: defaultProperties
    result: {}
    options:
      includeDetails: false
      includeMessage: false
      includeStack: false
    expectStack: false
    expectMessage: false
    expectProperties: false
  }
]


describe 'getResponseBody', ->
  for datum in testData
    do (datum) ->
      {description, message, properties, result, options} = datum

      err = new LawError message, properties
      stack = err.stack

      it description, (done) ->
        body = getResponseBody err, result, options
        should.exist body

        expected = {}

        _.merge expected, datum.properties if datum.expectProperties
        expected.message = message if datum.expectMessage
        expected.stack = stack if datum.expectStack

        body.should.eql expected

        done()
