class window.Buildings.FireTower1 extends Buildings.Tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'FireTower1'
    @bullet = FireBullet
    @controlledBullet = FireBullet

    @name = 'FireTower1'
    @range = 100
    @fireRate = 10000
    @bulletSpeed = 500
    @bulletStrength = 1
    super(@game, @hex)
