class window.Buildings.FireTower1 extends Buildings.tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'tower'
    @bullet = FireBullet
    @controlledBullet = FireBullet

    @range = 100
    @fireRate = 10000
    @bulletSpeed = 400
    @bulletStrength = 1
    super(@game, @hex)
