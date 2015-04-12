class window.Buildings.BasicTower1 extends Buildings.Tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BasicTower1'
    @bullet = BasicBullet
    @controlledBullet = BasicBullet

    @name = 'BasicTower1'
    @range = 300
    @fireRate = 500
    @bulletSpeed = 700
    @bulletStrength = 60
    super(@game, @hex)
