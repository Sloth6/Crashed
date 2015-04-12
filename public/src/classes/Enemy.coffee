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
      if b is null
        console.log("wtf")
      return if b is null
      collisionManager.enemyCollision @game, @sprite.container, b.sprite.container
  
    #pathfinding
    @newPath = false
    @path = []
    @i = 0
    @makePath hex

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

  makePath: (hex) ->
    hex ?= @nearestHex()
    @options.start = hex
    @path = astar.search @options
    @i = 0
    @nextHex = @path[@i]
    @newPath = false

  nearestHex: () ->
    # if it is on a hex, only checks the neighbors
    if @hex?
      nearest = hexUtils.nearestHex (hexUtils.neighbors @game.hexes, @hex.q, @hex.r), @sprite.position.x, @sprite.position.y
    # If that doesn't work, goes through all the hexes
    nearest or= hexUtils.nearestHex @game.hexes, @sprite.position.x, @sprite.position.y
    return nearest

  update: () ->
    return unless @alive
    @makePath() if @newPath

    @damage @hex.burnDamage

    if @nextHex.sprite
      @accelerateToObject(@sprite, @nextHex.sprite, @speed)
    d = @game.physics.arcade.distanceBetween @sprite, @nextHex.sprite
    if d < 40
      @i += 1
      @nextHex = @path[@i]
      return @kill() unless @nextHex
    else if d >= 200
      @options.start = @nearestHex()
      @path = astar.search @options
      @i = 0
      @nextHex = @path[@i]

    if @path[@i+1]
      d2 = @game.physics.arcade.distanceBetween @sprite, @path[@i+1].sprite
      if d2 < 40 and @path[@i+2]
        @i += 2
        @nextHex = @path[@i]
     
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
