should = require 'should'
connect = require 'connect'

make = require '../lib/adapter'


setup = (services={}, routes=[], config={}, options={}) ->

  host = config.host or 'localhost'
  port = config.port or 3000

  should.exist host
  should.exist port

  url = "http://#{host}:#{port}"

  app = connect()
  should.exist app

  adapter = make {services, routeDefs: routes, options}
  should.exist adapter, 'adapter should exist'

  app.use connect.bodyParser()
  app.use adapter

  server = app.listen port
  should.exist server, 'server should exist'

  return {app, server, url}


module.exports = setup