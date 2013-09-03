module.exports =
  indexThings: (args, done) ->
    done null, {data: 'indexThings'}

  showThing: (args, done) ->
    done null, {data: 'showThing'}

  createThing: (args, done) ->
    done null, {data: 'createThing'}

  updateThing: (args, done) ->
    done null, {data: 'updateThing'}