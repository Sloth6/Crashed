class window.SmallEnemy extends Enemy
  constructor: (@game, hex, healthModifier) ->
    # View
    @sprite = @game.enemyGroup.create hex.x, hex.y, 'enemy'
    @sprite.scale.set 0.5, 0.5

    # State
    @health = 50
    @maxHealth = 50
    @speed = 60
    @strength = 0.25
    @sprite.name = 'enemy'

    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 7

    super(hex, healthModifier)