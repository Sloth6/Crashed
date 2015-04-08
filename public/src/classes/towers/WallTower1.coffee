class window.Buildings.WallTower1 extends Buildings.Tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'WallTower1'
    @bullet = FireBullet
    @controlledBullet = FireBullet

    @name = 'WallTower1'
    @range = 100
    @fireRate = 10000
    @bulletSpeed = 400
    @bulletStrength = 1
    super(@game, @hex)
