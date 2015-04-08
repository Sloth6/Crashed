class window.FireBullet extends Bullet
  constructor: (@game, x, y, angle, @speed, @strength, @range) ->
    @sprite = @game.bulletGroup.create x, y, 'bullet'
    @sprite.scale.set(1.2, 1.2)
    console.log("made a bullet")
    super(@game, x, y, angle, @speed, @strength, @range)

  explode: () ->
    burningHex = hexUtils.nearestHex(@game.hexes, @sprite.x, @sprite.y)
    console.log(burningHex)
    burningHex.burnDamage = @strength
    burningHex.sprite.alpha = 0.25
    setTimeout ( ()=>
      burningHex.burnDamage = 0
      burningHex.sprite.alpha = 1
    ), 5000
  hitEnemy: (enemy) ->
    console.log("here")
    @explode()
    super(enemy)

