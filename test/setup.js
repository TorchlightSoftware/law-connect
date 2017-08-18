const should = require('should')
const connect = require('connect')
const bodyParser = require('body-parser')

const make = require('..')

const setup = function(services={}, routes=[], config={}, options={}) {
  const host = config.host || 'localhost'
  const port = config.port || 3000

  should.exist(host)
  should.exist(port)

  const url = `http://${host}:${port}`

  const app = connect()
  should.exist(app)

  const adapter = make({services, routeDefs: routes, options})
  should.exist(adapter, 'adapter should exist')

  app.use(bodyParser())
  app.use(adapter)

  const server = app.listen(port)
  should.exist(server, 'server should exist')

  return {app, server, url}
}

module.exports = setup
