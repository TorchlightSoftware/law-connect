module.exports = [
  {
    path: '/something',
    method: 'get',
    serviceName: 'indexThings'
  },
  {
    path: '/something/:id',
    method: 'get',
    serviceName: 'showThing'
  },
  {
    path: '/something/:id',
    method: 'post',
    serviceName: 'createThing'
  },
  {
    path: '/something/:id',
    method: 'put',
    serviceName: 'updateThing'
  },
  {
    // expecting this NOT to resolve
    path: '/nothing',
    method: 'get',
    serviceName: 'nothing'
  }
]
