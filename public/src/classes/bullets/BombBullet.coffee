class window.BombBullet extends Bullet
  constructor: (@game, @x, @y, angle, @speed, @strength, @range) ->
    # console.log @range
    @sprite = @game.bulletGroup.create x, y, 'bomb'
    @sprite.scale.set(1, 1)
    @area = 60
    @name = 'bomb'
    # @sprite.body.setCircle 5
    @game.bombs.push @
    super(@game, @x, @y, angle, @speed, @strength)
  explode: () ->

    explosion = @game.bulletGroup.create 0, 0, 'explosion'
    explosion.anchor.set 0.5, 0.5
    explosion.position = @sprite.position
    explosion.animations.add 'explode'
    explosion.animations.play 'explode', 50, false, true

    for e in @game.enemies
      distance = @game.physics.arcade.distanceBetween e.sprite, @sprite
      if distance < @area
        # angle = Math.atan2(e.sprite.x - @sprite.x, e.sprite.y - @sprite.y)
        # e.sprite.body.velocity.x += 100 * Math.cos(angle)
        # e.sprite.body.velocity.y += 100 * Math.sin(angle)
        e.damage(@strength)
    @game.bombs.remove @
  update: () ->
    d = ((@sprite.position.x - @x)**2 + (@sprite.position.y - @y)**2)**.5
    # console.log 'explode', d, @
    if d >= @range
      @explode()
      @sprite.kill()
  hitEnemy: (enemy) ->
    @explode()
    super(enemy)