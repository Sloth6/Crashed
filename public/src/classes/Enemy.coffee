class window.Enemy
  constructor: (@game, group, hex) ->
    # State
    @health = 100
    @speed = 5
    @alive = true

    # View
    @sprite = group.create hex.x, hex.y, 'enemy'
    @sprite.anchor.set 0.5, 0.5
    
    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 12

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

    # console.log @sprite.body
    # console.log @path
    # @nextHex = @path[0]

  kill: () ->
    @alive = false
    @sprite.kill()

  update: () ->
    if @game.physics.arcade.distanceBetween(@sprite, @nextHex.sprite) < 30
      @i += 1
      if @path[@i]
        @nextHex = @path[@i]
      else
        @kill()
    @accelerateToObject(@sprite, @nextHex.sprite, 100)

  accelerateToObject: (obj1, obj2, speed) ->
    angle = Math.atan2(obj2.y - obj1.y, obj2.x - obj1.x);
    obj1.body.rotation = angle
    obj1.body.velocity.x = Math.cos(angle) * speed 
    obj1.body.velocity.y = Math.sin(angle) * speed