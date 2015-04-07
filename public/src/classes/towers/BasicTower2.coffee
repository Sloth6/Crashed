class window.Buildings.BasicTower3 extends Buildings.tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'tower'
    @bullet = BasicBullet
    @controlledBullet = BasicBullet

    @range = 450
    @fireRate = 400
    @bulletSpeed = 600
    @bulletStrength = 200
    super(@game, @hex)
