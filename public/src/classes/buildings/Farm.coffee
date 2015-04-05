class Farm extends Building
  constructor: ( hex ) ->
    super hex, 'farm'
    @foodCost = -3

  act: () -> #Collect stuff
