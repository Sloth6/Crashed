class window.Buildings.BombTower1 extends Buildings.Tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BombTower1'
    @bullet = BombBullet
    @controlledBullet = BombBullet

    @name = 'BombTower1'
    @range = 300
    @fireRate = 500
    @bulletSpeed = 500
    @bulletStrength = 60
    super(@game, @hex)
