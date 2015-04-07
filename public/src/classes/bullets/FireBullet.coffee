class window.FireBullet extends Bullet
  constructor: (@game, x, y, angle, @speed, @strength, @range) ->
    @sprite = @game.bulletGroup.create x, y, 'bullet'
    @sprite.scale.set(1.2, 1.2)
    super(@game, x, y, angle, @speed, @strength, @range)

  explode: () ->
    (XYToHex @sprite.x, @sprite.y).burn

    for e in @game.enemies
      distance = @game.physics.arcade.distanceBetween e.sprite, @sprite
      if distance < @area
        angle = Math.atan2(e.sprite.x - @sprite.x, e.sprite.y - @sprite.y)
        e.sprite.body.velocity.x += 100 * Math.cos(angle)
        e.sprite.body.velocity.y += 100 * Math.sin(angle)
        e.damage(@strength)
    @game.bombs.remove @
  hitEnemy: (enemy) ->
    @explode()
    super(enemy)

