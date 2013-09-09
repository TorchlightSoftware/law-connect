capitalize = (s) -> "#{s[0].toUpperCase()}#{s.slice(1)}"

camelCase = (args...) ->
  prefix = args[0]
  return '' unless prefix

  suffix = args[1..].map(capitalize).join('')

  return "#{prefix}#{suffix}"


module.exports = {capitalize, camelCase}