url = require 'url'
path = require 'path'


capitalize = (s) -> "#{s[0].toUpperCase()}#{s.slice(1)}"


camelCase = (args...) ->
  prefix = args[0]
  return '' unless prefix

  suffix = args[1..].map(capitalize).join('')

  return "#{prefix}#{suffix}"


makeResource = (def) ->

  # name of one instance of the resource
  instance = def.instance || def.name

  # name of the collective resource
  collection = def?.collection || def.name

  # unless overridden, default to ':id' for instance ids
  if def?.idKey
    idKey = ":#{def.idKey}"
  else
    idKey = ':id'

  # submount the path if desired
  pathPrefix = def?.pathPrefix || '/'

  # local constants:
  #   basePath is the collection path prefix
  #   instancePath is the path prefix for one instance
  basePath = path.join pathPrefix, collection
  instancePath = path.join basePath, idKey

  # build array of auto-generated routes.
  # modeled after:
  #   http://guides.rubyonrails.org/routing.html#crud-verbs-and-actions
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
