class window.BombBullet extends Bullet
  constructor: (@game, @x, @y, angle, @dist) ->
    super(@game, @x, @y, angle)
    @sprite.scale.set(1, 1)
    @speed = 600
    @strength = 90
    @area = 60
    @range = 200
    @sprite.name = 'bomb'
    @sprite.body.setCircle 5
    @game.bombs.push @
  explode: () ->
    for e in @game.enemies
      distance = @game.physics.arcade.distanceBetween e.sprite, @sprite
      if distance < @area
        force = 1/Math.pow(distance, 2)
        angle = Math.atan2(e.sprite.x - @sprite.x, e.sprite.y - @sprite.y)
        e.sprite.body.velocity.x += 100 * Math.cos(angle)# * force
        e.sprite.body.velocity.y += 100 * Math.sin(angle)# * force
        e.damage(@strength)
    @sprite.kill()
    @game.bombs.remove @
  update: () ->
    d = ((@sprite.position.x - @x)**2 + (@sprite.position.y - @y)**2)**.5
    @explode() if d >= @dist or d >= @range
  hitEnemy: (enemy) ->
    @explode()
    super(enemy)