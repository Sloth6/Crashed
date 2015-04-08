class window.Buildings.FireTower1 extends Buildings.Tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BombTower'
    @bullet = FireBullet
    @controlledBullet = FireBullet

    @name = 'BombTower1'
    @range = 100
    @fireRate = 10000
    @bulletSpeed = 400
    @bulletStrength = 1
    super(@game, @hex)
