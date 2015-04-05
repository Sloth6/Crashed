class Base extends Building
  constructor: ( hex ) ->
    super hex, 'base'
  act: () ->
  onDeath: () ->
    console.trace()
    confirm 'YOU ARE BAD'