class window.Buildings.BombTower2 extends Buildings.Tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BombTower2'
    @sprite.scale.set 1.5, 1.5
    @bullet = BombBullet
    @controlledBullet = BombBullet

    @name = 'BombTower2'
    @range = 300
    @fireRate = 1500
    @bulletSpeed = 600
    @bulletStrength = 240
    super(@game, @hex)
