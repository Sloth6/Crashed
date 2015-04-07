class window.Buildings.BasicTower1 extends Buildings.tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'tower'
    @bullet = BasicBullet
    @controlledBullet = BasicBullet

    @range = 300
    @fireRate = 500
    @bulletSpeed = 500
    @bulletStrength = 60
    super(@game, @hex)
