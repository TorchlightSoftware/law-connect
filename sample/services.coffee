module.exports =
  indexThings:
    service: (args, done) ->
      done null, {data: 'indexThings'}

  showThing:
    service: (args, done) ->
      done null, {data: 'showThing'}

  createThing:
    service: (args, done) ->
      done null, {data: 'createThing'}

  updateThing:
    service: (args, done) ->
      done null, {data: 'updateThing'}