class window.SmallEnemy extends Enemy
  constructor: (@game, hex, healthModifier) ->
    # View
    @sprite = @game.enemyGroup.create hex.x, hex.y, 'enemy'

    # State
    @health = 50
    @maxHealth = 50
    @speed = 60
    @alive = true
    @sprite.name = 'enemy'

    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 7

    # Pathing
    @options =
      graph: @game.hexes
      end: @game.hexes["0:0"]
      impassable: (h) -> h.building instanceof Buildings.Wall
      heuristic: hexUtils.hexDistance
      neighbors: hexUtils.neighbors

    super(hex, healthModifier)