url = require 'url'
path = require 'path'


capitalize = (s) -> "#{s[0].toUpperCase()}#{s.slice(1)}"


camelCase = (args...) ->
  prefix = args[0]
  return '' unless prefix

  suffix = args[1..].map(capitalize).join('')

  return "#{prefix}#{suffix}"


makeResource = (def) ->

  instance = def.instance || def.name
  collection = def?.collection || def.name
  idKey = def?.idKey || ':id'

  pathPrefix = def?.pathPrefix || '/'

  basePath = path.join pathPrefix, collection
  instancePath = path.join basePath, idKey

  routeDefs = [
    # GET /photos -> #index
    # display a list of all photos
    {
      path: basePath
      method: 'get'
      serviceName: camelCase 'index', collection
    }
    # GET /photos/new -> #new
    # return an HTML form for creating a new photo
    {
      path: path.join basePath, 'new'
      method: 'get'
      serviceName: camelCase 'new', instance
    }
    # POST /photos -> #create
    # create a new photo
    {
      path: basePath
      method: 'post'
      serviceName: camelCase 'create', instance
    }
    # GET /photos/:id -> #show
    # display a specific photo
    {
      path: instancePath
      method: 'get'
      serviceName: camelCase 'show', instance
    }
    # GET /photos/:id/edit -> #edit
    # return an HTML form for editing a photo
    {
      path: path.join instancePath, 'edit'
      method: 'get'
      serviceName: camelCase 'edit', instance
    }
    # PATCH/PUT /photos/:id -> #update
    # update a specific photo
    {
      path: instancePath
      method: 'patch'
      serviceName: camelCase 'update', instance
    }
    {
      path: instancePath
      method: 'put'
      serviceName: camelCase 'update', instance
    }
    # DELETE /photos/:id -> #destroy
    # delete a specific photo
    {
      path: instancePath
      method: 'delete'
      serviceName: camelCase 'delete', instance
    }
  ]

module.exports = makeResource
