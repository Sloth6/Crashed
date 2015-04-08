class window.BombBullet extends Bullet
  constructor: (@game, @x, @y, angle, @speed, @strength, @range) ->
    @sprite = @game.bulletGroup.create x, y, 'bomb'
    @sprite.scale.set(1, 1)
    @area = 60
    @name = 'bomb'
    # @sprite.body.setCircle 5
    @game.bombs.push @
    super(@game, @x, @y, angle, @speed, @strength)
  explode: () ->
    for e in @game.enemies
      distance = @game.physics.arcade.distanceBetween e.sprite, @sprite
      if distance < @area
        angle = Math.atan2(e.sprite.x - @sprite.x, e.sprite.y - @sprite.y)
        e.sprite.body.velocity.x += 100 * Math.cos(angle)
        e.sprite.body.velocity.y += 100 * Math.sin(angle)
        e.damage(@strength)
    @game.bombs.remove @
  update: () ->
    d = ((@sprite.position.x - @x)**2 + (@sprite.position.y - @y)**2)**.5
    if d >= @range
      @explode()
      @sprite.kill()
  hitEnemy: (enemy) ->
    @explode()
    super(enemy)