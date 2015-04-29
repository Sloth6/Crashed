class window.Bullet

  constructor: (@game, x, y, angle, @speed, @strength, @target, @size) ->
    # View
    @sprite.anchor.set 0.5, 0.5
    @size ?= 1.0
    @sprite.scale.set @size, @size

    # State
    @health = 1
    @sprite.name = 'bullet'
    @sprite.container = @
    
    # Physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle 8 * @size

    @sprite.body.setCollisionGroup @game.bulletCG
    @sprite.body.collides [ @game.enemyCG ]
    @sprite.body.data.shapes[0].sensor = true
    @sprite.body.collideWorldBounds = true
    
    @sprite.body.rotation = angle
    @sprite.body.velocity.x = Math.cos(angle) * @speed
    @sprite.body.velocity.y = Math.sin(angle) * @speed
  hitEnemy: (enemy) ->
    enemy.damage @strength
    @sprite.kill()
