module.exports = [
  {
    path: '/something',
    method: 'get',
    serviceName: 'indexThings'
  },
  {
    resource: {
      name: 'photos',
      instance: 'photo'
    }
  },
  {
    // we expected this NOT to resolve
    path: '/nothing',
    method: 'get',
    serviceName: 'nothing'
  }
]
