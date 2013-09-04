module.exports = [
  {
    path: '/something'
    method: 'get'
    serviceName: 'indexThings'
  }
  {
    resource:
      name: 'photos'
      instance: 'photo'
  }
  {
    # we expected this NOT to resolve to a service, thus
    # to resolve to the default `noService` 501 service
    path: '/nothing'
    method: 'get'
    serviceName: 'nothing'
  }
]
