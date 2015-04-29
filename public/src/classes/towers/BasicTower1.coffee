class window.Buildings.BasicTower1 extends Buildings.Tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BasicTower1'
    @sprite.scale.set 1.0, 1.0
    @bullet = BasicBullet
    @controlledBullet = BasicBullet

    @name = 'BasicTower1'
    @range = 200
    @fireRate = 500
    @bulletSpeed = 2000
    @bulletStrength = 200
    super(@game, @hex)
