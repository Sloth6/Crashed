class window.Enemy
  constructor: (@hex, healthModifier) ->
    #state
    @health *= healthModifier
    @maxHealth *= healthModifier
    @maxSpeed = 50

    #view
    @sprite.anchor.set 0.5, 0.5
    @sprite.container = @

    #physics
    @sprite.scale.set(0.5, 0.5)
    @sprite.body.setCollisionGroup @game.enemyCG
    @sprite.body.collides [ @game.enemyCG, @game.buildingCG, @game.bulletCG ]
    @sprite.body.onBeginContact.add (b) =>
      return unless b
      collisionManager.enemyCollision @game, @sprite.container, b.sprite.container
  
    @nextHex = @hex.closestNeighbor

  kill: () ->
    return unless @alive
    @alive = false
    @game.enemyCount -= 1
    @game.remainingText.setText "Enemies remaining: #{@game.enemyCount}"
    @game.updateStatsText()
    @sprite.kill()

  damage: (n) ->
    @health -= n
    @sprite.alpha = @health / @maxHealth
    @kill() if @health <= 0
    @alive

  nearestHex: () ->
    # if it is on a hex, only checks the neighbors
    if @hex?
      nearest = hexUtils.nearestHex (hexUtils.neighbors @game.hexes, @hex.q, @hex.r), @sprite.position.x, @sprite.position.y
    # If that doesn't work, goes through all the hexes
    nearest or= hexUtils.nearestHex @game.hexes, @sprite.position.x, @sprite.position.y
    return nearest

  update: () ->
    return unless @alive
    @nextHex = @nearestHex() if !@nextHex
    return unless @nextHex

    @damage @hex.burnDamage

    if @nextHex.sprite
      speed = if @nextHex.nature is 'trees' then @speed/2 else @speed
      @accelerateToObject(@sprite, @nextHex.sprite, speed)
    d = @game.physics.arcade.distanceBetween @sprite, @nextHex.sprite
    if d < 40
      @nextHex = @nextHex.closestNeighbor
    else if d >= 200
      @nextHex = @nearestHex()

  accelerateToObject: (obj1, obj2, speed) ->
    angle = Math.atan2 obj2.y - obj1.y, obj2.x - obj1.x
    obj1.body.rotation = angle
    expectedXVel = Math.cos(angle) * speed
    expectedYVel = Math.sin(angle) * speed
    fMult = 4
    obj1.body.force.x = (expectedXVel - obj1.body.velocity.x) * fMult + Math.random() * 3
    obj1.body.force.y = (expectedYVel - obj1.body.velocity.y) * fMult  + Math.random() * 3
    obj1.body.velocity.x = Math.min obj1.body.velocity.x, (@maxSpeed / @hex.getCost())
    obj1.body.velocity.y = Math.min obj1.body.velocity.y, (@maxSpeed / @hex.getCost())
