class window.BigEnemy extends Enemy
  constructor: (@game, hex) ->
    # View
    @sprite = @game.enemyGroup.create hex.x, hex.y, 'bigEnemy'
    @sprite.anchor.set 0.5, 0.5
    @sprite.container = @

    # State
    @health = 200
    @speed = 50
    @alive = true
    @sprite.name = 'enemy'

    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 14
    @sprite.scale.set(0.5, 0.5)
    @sprite.body.setCollisionGroup @game.enemyCG
    @sprite.body.collides [ @game.enemyCG, @game.buildingCG, @game.bulletCG ]
    @sprite.body.onBeginContact.add (b) => @game.enemyHit @sprite, b.sprite
  
    # Pathing
    @options =
      graph: @game.hexes
      start: hex
      end: @game.hexes["0:0"]
      impassable: (h) => false
      heuristic: hexUtils.hexDistance
      neighbors: hexUtils.neighbors

    @path = astar.search @options
    @i = 0
    @nextHex = @path[@i]