class window.Enemy
  constructor: (@hex, healthModifier) ->
    #state
    @alive = true
    @health = 100 * (1+healthModifier)
    @maxHealth = 100 * (1+healthModifier)
    @maxSpeed = 50
    @state = 'moving'
    
    #view
    @sprite.anchor.set 0.5, 0.5
    @sprite.container = @

    #physics
    @sprite.scale.set(0.5, 0.5)
    @sprite.body.setCollisionGroup @game.enemyCG
    @sprite.body.collides [ @game.buildingCG, @game.bulletCG, @game.enemyCG ]
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

  # nearestHex: () ->
  #   # if it is on a hex, only checks the neighbors
  #   if @hex?
  #     nearest = hexUtils.nearestHex (hexUtils.neighbors @game.hexes, @hex.q, @hex.r), @sprite.position.x, @sprite.position.y
  #   # If that doesn't work, goes through all the hexes
  #   nearest or= hexUtils.nearestHex @game.hexes, @sprite.position.x, @sprite.position.y
  #   return nearest

  update: () ->
    return unless @alive
    if !@nextHex
      # obj1.body.velocity = 0
      # obj1.body.velocity = 0
      @nextHex = @hex.closestNeighbor
      return
      # console.log 'oops'
    
    # console.log 'here'
    @damage @hex.burnDamage
    speed = if @nextHex.nature is 'trees' then @speed/2 else @speed
    @accelerateToObject(@sprite, @nextHex.sprite, speed)
   
    # b = @nextHex.building 
    # if b
    #   # building_alive = b.damage @strength
    #   if not building_alive and b instanceof Buildings.Wall
    #     window.pathfinding.run @game
        # game.enemies.forEach (e) ->
        #   e.newPath = true if e instanceof SmallEnemy

    d = @game.physics.arcade.distanceBetween @sprite, @nextHex.sprite
    if d < 30
      @hex = @nextHex
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
