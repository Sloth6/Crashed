class Collector extends Building
  constructor: ( hex ) ->
    super hex, 'collector'
    @foodCost = 1
  act: () -> #Collect stuff
  onEndRound: () ->
    @hex.gold -= 20
    game.addGold 20