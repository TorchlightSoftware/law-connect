url = require 'url'
path = require 'path'

{capitalize, camelCase} = require './util'


makeResource = (routeDef) ->
  # If `resource` is not a key in `routeDef`, then the
  # routeDef does not define a resource, so we don't want
  # to auto-expand it, and should return early.
  return routeDef unless routeDef.resource?
  def = routeDef.resource

  # name of one instance of the resource
  instance = def.instance or def.name

  # name of the collective resource
  collection = def?.collection or def.name

  # unless overridden, default to ':id' for instance ids
  if def?.idKey
    idKey = ":#{def.idKey}"
  else
    idKey = ':id'

  # submount the path if desired
  pathPrefix = def?.pathPrefix or '/'

  # local constants:
  #   basePath is the collection path prefix
  #   instancePath is the path prefix for one instance
  basePath = path.join '/', pathPrefix, collection
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
      serviceName: "#{collection}/index"
    }
    # GET /photos/new -> #new
    # return an HTML form for creating a new photo
    {
      path: path.join basePath, 'new'
      method: 'get'
      serviceName: "#{collection}/new"
    }
    # POST /photos -> #create
    # create a new photo
    {
      path: basePath
      method: 'post'
      serviceName: "#{collection}/create"
    }
    # GET /photos/:id -> #show
    # display a specific photo
    {
      path: instancePath
      method: 'get'
      serviceName: "#{collection}/show"
    }
    # GET /photos/:id/edit -> #edit
    # return an HTML form for editing a photo
    {
      path: path.join instancePath, 'edit'
      method: 'get'
      serviceName: "#{collection}/edit"
    }
    # PATCH/PUT /photos/:id -> #update
    # update a specific photo
    {
      path: instancePath
      method: 'patch'
      serviceName: "#{collection}/update"
    }
    {
      path: instancePath
      method: 'put'
      serviceName: "#{collection}/update"
    }
    # DELETE /photos/:id -> #destroy
    # delete a specific photo
    {
      path: instancePath
      method: 'delete'
      serviceName: "#{collection}/delete"
    }
  ]

module.exports = makeResource
