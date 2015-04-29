class window.Buildings.BasicTower3 extends Buildings.Tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BasicTower3'
    @sprite.scale.set 2.0, 2.0
    @bullet = BasicBullet
    @controlledBullet = BasicBullet

    @name = 'BasicTower3'
    @range = 1500
    @fireRate = 100
    @bulletSpeed = 3000
    @bulletStrength = 1500
    @bulletScale = 4.0
    super(@game, @hex)
