class window.Buildings.Pylon extends Building
  constructor: (@game, @hex) ->
    # View
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'Pylon'
    
    # State
    @health = 5
    @name = 'Pylon'

    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 35
    super()