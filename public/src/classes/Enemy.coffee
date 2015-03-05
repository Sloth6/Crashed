class window.Enemy
  constructor: (@game, hex) ->
    # View
    @sprite = @game.enemyGroup.create hex.x, hex.y, 'enemy'
    @sprite.anchor.set 0.5, 0.5
    @sprite.container = @

    # State
    @health = 100
    @speed = 5
    @alive = true
    @sprite.name = 'enemy'

    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 14
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
    @alive = false
    @sprite.kill()

  damage: (n) ->
    @health -= n
    @kill() if @health <= 0
    @alive

  update: () ->
    return unless @alive
    @accelerateToObject(@sprite, @nextHex.sprite, 50)
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
    obj1.body.velocity.x = (Math.cos(angle) * speed) + Math.random()*3
    obj1.body.velocity.y = (Math.sin(angle) * speed) + Math.random()*3