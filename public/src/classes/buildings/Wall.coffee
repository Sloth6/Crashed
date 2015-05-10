class window.Buildings.Wall extends Building
  constructor: (@game, @hex) ->
    # View
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'Wall'
    
    # State
    @health = 100
    @name = 'Wall'

    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 35
    super()

  kill : () ->
    pathfinding.run @game
    super()