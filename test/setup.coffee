should = require 'should'
connect = require 'connect'

make = require '../lib/makeAdapter'


setup = (services={}, routes={}, config={}) ->

  host = config.host || 'localhost'
  port = config.port || 3000

  should.exist host
  should.exist port

  url = "http://#{host}:#{port}"

  app = connect()
  should.exist app

  adapter = make services, routes
  should.exist adapter

  app.use connect.bodyParser()
  app.use adapter

  server = app.listen port
  should.exist server

  return {app, server, url}


module.exports = setup