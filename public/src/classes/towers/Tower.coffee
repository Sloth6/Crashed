class window.Buildings.Tower
  constructor: (@game, @hex) ->
    # View
    @sprite.anchor.set 0.5, 0.5
    graphics = game.add.graphics 0, 0
    graphics.lineStyle 1, 0xFF0000, .6
    graphics.drawCircle 0,0, @range*2 / @sprite.scale.x
    @sprite.addChild graphics

    # State
    @health = 100
    @alive = true
    @target = null #Enemy Object
    @sprite.container = @
    @nextFire = 0
    @controlledBullet or= null

    # Physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 15
    @sprite.body.static = true
    @sprite.body.setCollisionGroup @game.buildingCG
    @sprite.body.collides [ @game.enemyCG ]

  kill: () ->
    @alive = false
    @sprite.kill()

  findTarget: () ->
    minD = Infinity
    @target = null
    for e in @game.enemies
      continue unless e.alive
      # console.log @game.physics.P2.distanceBetween @sprite, e.sprite
      d = @game.physics.arcade.distanceBetween @sprite, e.sprite
      if d < minD and d <= @range
        minD = d
        @target = e
    true

  ###
  # Points the tower toward the next target
  # Returns true if sucessful
  # Returns false if there are not yet enemies to aim at
  ###
  aim: () ->
    haveTarget = @target?.alive
    targetInRange = false
    if haveTarget
      dist = @game.physics.arcade.distanceBetween @sprite, @target.sprite
      targetInRange = (dist <= @range)

    if targetInRange
      angle = Math.atan2(@target.sprite.y - @sprite.y, @target.sprite.x - @sprite.x)
      @sprite.body.rotation = angle or @sprite.body.rotation
      return true
    else
      @findTarget()
      return false  
    

  fire: () ->
    @nextFire = @game.time.now + @fireRate
    bullet = if @controlled then @controlledBullet else @bullet
    new bullet @game, @sprite.x, @sprite.y, @sprite.body.rotation, @bulletSpeed, @bulletStrength, @target, @bulletScale

  update: () ->
    return unless @alive
    @controlled = @hex.selected and @game.mode == 'attack'
    if @game.mode == 'attack'
      if @game.time.now > @nextFire and @aim()
        @fire()
