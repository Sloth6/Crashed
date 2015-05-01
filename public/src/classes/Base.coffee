class window.Buildings.Base
  constructor: (@game, @hex) ->
    # View
    @sprite = @game.buildingGroup.create @hex.x, @hex.y-10, 'Base'
    @sprite.anchor.set 0.5, 0.5
    @sprite.container = @
    
    # State
    @name = 'Base'
    @container = @

    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 35
    @sprite.body.static = true
    @sprite.body.setCollisionGroup @game.buildingCG
    @sprite.body.collides [ @game.enemyCG ]

  kill: () ->
    @alive = false
    @sprite.kill()
    @game.state.start 'Game'
