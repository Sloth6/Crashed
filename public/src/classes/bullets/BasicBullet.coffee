class window.BasicBullet extends Bullet
  constructor: (@game, x, y, angle, @speed, @strength, @target, @size) ->
    @sprite = @game.bulletGroup.create x, y, 'bullet'
    super(@game, x, y, angle, @speed, @strength, @target, @size)