class window.BasicBullet extends Bullet
  constructor: (@game, x, y, angle, @speed, @strength, @range) ->
    @sprite = @game.bulletGroup.create x, y, 'bullet'
    @sprite.scale.set(0.4, 0.4)
    super(@game, x, y, angle, @speed, @strength, @range)