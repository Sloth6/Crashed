class window.Enemy
  constructor: (startHex, healthModifier) ->
    #state
    @alive = true
    @health = 100 * (1+healthModifier)
    @maxHealth = 100 * (1+healthModifier)
    @maxSpeed = 50
    @attacking = false
    @updatePath = false
    
    #view
    @sprite.anchor.set 0.5, 0.5
    @sprite.container = @
    
    #physics
    @sprite.body.setCollisionGroup @game.enemyCG
    @sprite.body.collides [@game.enemyCG]
    @sprite.body.onBeginContact.add (b) =>
      return unless b
      collisionManager.enemyCollision @game, @sprite.container, b.sprite.container
  
    @nextHex = startHex.closestNeighbor

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

  update: () ->
    if !@alive
      return

    if @updatePath
      @nextHex = @nextHex.closestNeighbor
      @updatePath = false
      console.log 'no path'
      return

    # if !@nextHex
    #   return

    @damage @nextHex.burnDamage
    if @attacking
      if not @nextHex.building
        @attacking = false
      else
        @nextHex.building.damage @strength

    d = @game.physics.arcade.distanceBetween @sprite, @nextHex.sprite
    speed = @nextHex.enemySpeed
    @accelerateToObject @sprite, @nextHex.sprite, speed   
    
    if d < 30 and (@nextHex.building is null or !@nextHex.building.alive)
      @nextHex = @nextHex.closestNeighbor



  accelerateToObject: (obj1, obj2, speed) ->
    angle = Math.atan2 obj2.y - obj1.y, obj2.x - obj1.x
    obj1.body.rotation = angle
    expectedXVel = Math.cos(angle) * speed
    expectedYVel = Math.sin(angle) * speed
    fMult = 4
    obj1.body.force.x = (expectedXVel - obj1.body.velocity.x) * fMult + Math.random() * 3
    obj1.body.force.y = (expectedYVel - obj1.body.velocity.y) * fMult  + Math.random() * 3
    # obj1.body.velocity.x = Math.min obj1.body.velocity.x, (@maxSpeed / @hex.getCost())
    # obj1.body.velocity.y = Math.min obj1.body.velocity.y, (@maxSpeed / @hex.getCost())
