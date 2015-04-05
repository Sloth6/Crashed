class window.Buildings.tower
  constructor: (@game, @hex) ->
    # View
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'tower'
    @sprite.anchor.set 0.5, 0.5

    # State
    @health = 100
    @alive = true
    @range = 300
    @target = null #Enemy Object
    @sprite.name = 'tower'
    @sprite.container = @
    @fireRate = 500
    @nextFire = 0

    # Physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 15
    @sprite.body.static = true
    @sprite.body.setCollisionGroup @game.buildingCG
    @sprite.body.collides [ @game.enemyCG ]

  kill: () ->
    @alive = false
    @sprite.kill()

  # Each tower shouldn't have to implement this
  findTarget: () ->
    minD = Infinity
    for e in @game.enemies
      continue unless e.alive
      d = @game.physics.arcade.distanceBetween @sprite, e.sprite
      if d < minD and d < @range 
        minD = d
        @target = e

  # This should be an empty method that each tower implements
  controlledFire: () ->
    true
  # This should be an empty method that each tower implements
  fire: () ->
    true
  # Each tower shouldn't have to impelement this    
  update: () ->
    return unless @alive
    # Tower control
    if @hex.selected and @game.mode == 'attack'
      controlledFire()
    else if @target? and @target.alive
      d = @game.physics.arcade.distanceBetween @sprite, @target.sprite
      if d > @range
        @target = null
      else
      @fire()
    else
      @findTarget()
    true
