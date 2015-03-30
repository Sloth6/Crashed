class window.Enemy
  constructor: (@game, hex) ->
    # View
    @sprite = @game.enemyGroup.create hex.x, hex.y, 'enemy'
    @sprite.anchor.set 0.5, 0.5
    @sprite.container = @

    # State
    @health = 100
    @speed = 50
    @alive = true
    @sprite.name = 'enemy'

    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 10
    @sprite.scale.set(0.5, 0.5)
    @sprite.body.setCollisionGroup @game.enemyCG
    @sprite.body.collides [ @game.enemyCG, @game.buildingCG, @game.bulletCG ]
    @sprite.body.onBeginContact.add (b) => @game.enemyHit @sprite, b.sprite
  
    # Pathing
    options =
      graph: @game.hexes
      start: hex
      end: @game.hexes["0:0"]
      impassable: (h) => h.building is 'wall'
      heuristic: hexUtils.hexDistance
      neighbors: hexUtils.neighbors

    @path = astar.search options
    @i = 0
    @nextHex = @path[@i]

  kill: () ->
    return unless @alive
    @alive = false
    @game.enemyCount -= 1
    @game.remainingText.setText "Enemies remaining: #{@game.enemyCount}"
    @game.updateStatsText()
    @game.money++
    @sprite.kill()

  damage: (n) ->
    @health -= n
    @kill() if @health <= 0
    @alive

  update: () ->
    return unless @alive
    @accelerateToObject(@sprite, @nextHex.sprite, @speed)
    d = @game.physics.arcade.distanceBetween @sprite, @nextHex.sprite
    if d < 40
      @i += 1
      @nextHex = @path[@i]
      return @kill() unless @nextHex
    if @path[@i+1]
      d2 = @game.physics.arcade.distanceBetween @sprite, @path[@i+1].sprite
      if d2 < 40 and @path[@i+2]
        @i += 2
        @nextHex = @path[@i]
    

  accelerateToObject: (obj1, obj2, speed) ->
    angle = Math.atan2(obj2.y - obj1.y, obj2.x - obj1.x);
    obj1.body.rotation = angle
    expectedXVel = Math.cos(angle) * speed
    expectedYVel = Math.sin(angle) * speed
    fMult = 1
    obj1.body.force.x = (expectedXVel - obj1.body.velocity.x) * fMult + Math.random() * 3 
    obj1.body.force.y = (expectedYVel - obj1.body.velocity.y) * fMult  + Math.random() * 3
