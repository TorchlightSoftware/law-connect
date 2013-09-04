module.exports = (args, done) ->
  # https://tools.ietf.org/html/rfc2616#section-10.5.2
  done (new Error '501 Not Implemented'), {}