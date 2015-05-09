class window.Buildings.Base extends Building
  constructor: (@game, @hex) ->
    # View
    @sprite = @game.buildingGroup.create @hex.x, @hex.y-10, 'Base'

    # State
    @health = 1
    @name = 'Base'

    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 35
    super()

  kill: () ->
    super()
    @game.state.start 'Game'
