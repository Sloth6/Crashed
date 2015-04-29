class window.Buildings.BasicTower2 extends Buildings.Tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BasicTower1'
    @sprite.scale.set 1.5, 1.5
    @bullet = BasicBullet
    @controlledBullet = BasicBullet

    @name = 'BasicTower2'
    @range = 450
    @fireRate = 200
    @bulletSpeed = 2000
    @bulletStrength = 500
    @bulletScale = 2.0
    super(@game, @hex)
