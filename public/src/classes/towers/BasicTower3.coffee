class window.Buildings.BasicTower3 extends Buildings.tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'tower'
    @bullet = BasicBullet
    @controlledBullet = BasicBullet

    @range = 1500
    @fireRate = 400
    @bulletSpeed = 800
    @bulletStrength = 500
    super(@game, @hex)
