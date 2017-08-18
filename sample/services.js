module.exports = {
  indexThings: {
    service(args, done) {
      return done(null, {data: 'indexThings'})
    }
  },

  showThing: {
    service(args, done) {
      return done(null, {data: 'showThing'})
    }
  },

  createThing: {
    service(args, done) {
      return done(null, {data: 'createThing'})
    }
  },

  updateThing: {
    service(args, done) {
      return done(null, {data: 'updateThing'})
    }
  }
}
