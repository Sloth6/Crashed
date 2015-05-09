class window.Buildings.Collector extends Building
  constructor: (@game, @hex) ->
    # View
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'Collector'
    
    # State
    @health = 5
    @name = 'Collector'

    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 35
    super()

  kill : () ->
    pathfinding.run @game
    super()