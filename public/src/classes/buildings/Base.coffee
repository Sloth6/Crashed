class window.Base extends Building
  @cost = 0
  @upgrades = [
    {
      name: 'click'
      func: (game, hex) -> game.playerUpgrades.push 'Click'
      cost: 5
      purchased: false
    }
  ]
  constructor: (@game, @hex) ->
    # View
    @sprite = @game.buildingGroup.create @hex.x, @hex.y-10, 'Base'

    # State
    @health = 1
    @name = 'Base'
    @r = 35
    super()

  destroy: () ->
    super()
    @game.state.start 'Game'
