class window.Buildings.BasicTower3 extends Buildings.Tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BombTower1'
    @bullet = BasicBullet
    @controlledBullet = BasicBullet

    @name = 'BasicTower3'
    @range = 1500
    @fireRate = 400
    @bulletSpeed = 800
    @bulletStrength = 500
    super(@game, @hex)
