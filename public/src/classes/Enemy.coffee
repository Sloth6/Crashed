class window.Enemy
  constructor: (@game, group, hex) ->
    # State
    @health = 100
    @speed = 5

    # View
    @sprite = group.create hex.x, hex.y, 'enemy'
    @sprite.anchor.set 0.5, 0.5
    
    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 12
    # @sprite.body.setCollisionGroup game.enemyCollisionGroup
    # @sprite.body.collides([pandaCollisionGroup])

    # Pathing
    @nextHex = @game.hexes["0:0"]

  update: () ->
    @accelerateToObject(@sprite, @nextHex.sprite, 30)

  accelerateToObject: (obj1, obj2, speed) ->
    angle = Math.atan2(obj2.y - obj1.y, obj2.x - obj1.x);
    obj1.body.rotation = angle
    obj1.body.force.x = Math.cos(angle) * speed    # accelerateToObject 
    obj1.body.force.y = Math.sin(angle) * speed