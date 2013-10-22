url = require 'url'

makeResource = (routeDef) ->
  # If `resource` is not a key in `routeDef`, then the
  # routeDef does not define a resource, so return it unmodified.
  return routeDef unless routeDef.resource?

  # unless overridden, default to ':id' for instance ids
  if routeDef.id?
    idKey = ":#{routeDef.id}"
  else
    idKey = ':id'

  if routeDef.prefix? and not routeDef.prefix.match /^\//
    routeDef.prefix = '/' + routeDef.prefix

  # prefix the path if desired
  joinUrl = (parts...) ->
    [parts...].join '/'

  #   basePath is the resource path prefix
  #   instancePath is the path prefix for one instance
  basePath = joinUrl routeDef.prefix, routeDef.resource
  instancePath = joinUrl basePath, idKey

  # build array of auto-generated routes.
  # modeled after:
  #   http://guides.rubyonrails.org/routing.html#crud-verbs-and-actions
  routeDefs = [
    # GET /photos -> #index
    # display a list of all photos
    {
      path: basePath
      method: 'get'
      serviceName: "#{routeDef.resource}/index"
    }
    # GET /photos/new -> #new
    # return an HTML form for creating a new photo
    {
      path: joinUrl basePath, 'new'
      method: 'get'
      serviceName: "#{routeDef.resource}/new"
    }
    # POST /photos -> #create
    # create a new photo
    {
      path: basePath
      method: 'post'
      serviceName: "#{routeDef.resource}/create"
    }
    # GET /photos/:id -> #show
    # display a specific photo
    {
      path: instancePath
      method: 'get'
      serviceName: "#{routeDef.resource}/show"
    }
    # GET /photos/:id/edit -> #edit
    # return an HTML form for editing a photo
    {
      path: joinUrl instancePath, 'edit'
      method: 'get'
      serviceName: "#{routeDef.resource}/edit"
    }
    # PATCH/PUT /photos/:id -> #update
    # update a specific photo
    {
      path: instancePath
      method: 'patch'
      serviceName: "#{routeDef.resource}/update"
    }
    {
      path: instancePath
      method: 'put'
      serviceName: "#{routeDef.resource}/update"
    }
    # DELETE /photos/:id -> #destroy
    # delete a specific photo
    {
      path: instancePath
      method: 'delete'
      serviceName: "#{routeDef.resource}/delete"
    }
  ]

module.exports = makeResource
