class window.Pylon extends Building
  @cost = 4
  @upgrades = []
  constructor: (@game, @hex) ->
    # View
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'Pylon'
    @sprite.scale.set 0.2, 0.2
    
    # State
    @health = 5
    @name = 'Pylon'

    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 10#35
    super()