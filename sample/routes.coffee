module.exports = [
  {
    path: '/something'
    method: 'get'
    serviceName: 'indexThings'
  }
  {
    path: '/something/:id'
    method: 'get'
    serviceName: 'showThing'
  }
  {
    path: '/something/:id'
    method: 'post'
    serviceName: 'createThing'
  }
  {
    path: '/something/:id'
    method: 'put'
    serviceName: 'updateThing'
  }
  {
    # we expected this NOT to resolve to a service, thus
    # to resolve to the default `noService` 501 service
    path: '/nothing'
    method: 'get'
    serviceName: 'nothing'
  }
]
