class window.Buildings.wall
  constructor: (@game, @hex) ->
    # View
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'wall'
    @sprite.anchor.set 0.5, 0.5
    @sprite.container = @
    
    # State
    @health = 100
    @maxHealth = 100
    @sprite.name = 'wall'
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
    @game.buildings.remove @
    @hex.building = null
    true

  damage: (n) ->
    @health -= n
    @sprite.alpha = @health / @maxHealth
    @kill() if @health <= 0
    @alive
