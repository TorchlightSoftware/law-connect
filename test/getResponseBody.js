const should = require('should')
const _ = require('lodash')
const {errors} = require('law')
const {LawError} = errors

const getResponseBody = require('../lib/getResponseBody')

const defaultProperties = {
  x: 100,
  y: [2,3,5],
  z: 'hello!'
}

const defaultMessage = 'uh-oh!'

const testData = [
  {
    description: 'should keep properties, stack, and message by default',
    message: defaultMessage,
    properties: defaultProperties,
    result: {},
    options: {},
    expectStack: true,
    expectMessage: true,
    expectProperties: true
  },
  {
    description: 'should keep properties, stack, and message when told to',
    message: defaultMessage,
    properties: defaultProperties,
    result: {},
    options: {
      includeDetails: true,
      includeMessage: true,
      includeStack: true
    },
    expectStack: true,
    expectMessage: true,
    expectProperties: true
  },
  {
    description: 'should exclude stack when told to',
    message: defaultMessage,
    properties: defaultProperties,
    result: {},
    options: {
      includeStack: false
    },
    expectStack: false,
    expectMessage: true,
    expectProperties: true
  },
  {
    description: 'should exclude message when told to',
    message: defaultMessage,
    properties: defaultProperties,
    result: {},
    options: {
      includeMessage: false
    },
    expectStack: true,
    expectMessage: false,
    expectProperties: true
    },
  {
    description: 'should exclude properties when told to',
    message: defaultMessage,
    properties: defaultProperties,
    result: {},
    options: {
      includeDetails: false
    },
    expectStack: true,
    expectMessage: true,
    expectProperties: false
  },
  {
    description: 'should exclude everything when told to',
    message: defaultMessage,
    properties: defaultProperties,
    result: {},
    options: {
      includeDetails: false,
      includeMessage: false,
      includeStack: false
    },
    expectStack: false,
    expectMessage: false,
    expectProperties: false
  }
]

describe('getResponseBody', () =>
  Array.from(testData).map((datum) =>
    (function(datum) {
      const {description, message, properties, result, options} = datum

      const err = new LawError(message, properties)
      const { stack } = err

      return it(description, function(done) {
        const body = getResponseBody(err, result, options)
        should.exist(body)

        const expected = {}

        if (datum.expectProperties) { _.merge(expected, datum.properties) }
        if (datum.expectMessage) { expected.message = message }
        if (datum.expectStack) { expected.stack = stack }

        body.should.eql(expected)

        return done()
      })
    })(datum))
)
