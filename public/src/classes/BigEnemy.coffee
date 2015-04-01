class window.BigEnemy extends Enemy
  constructor: (@game, hex, healthModifier) ->
    # View
    @sprite = @game.enemyGroup.create hex.x, hex.y, 'bigEnemy'

    # State
    @health = 200
    @maxHealth = 200
    @speed = 50
    @alive = true
    @sprite.name = 'enemy'

    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 14

    # Pathing
    @options =
      graph: @game.hexes
      end: @game.hexes["0:0"]
      impassable: (h) => false
      heuristic: hexUtils.hexDistance
      neighbors: hexUtils.neighbors

    super(hex, healthModifier)