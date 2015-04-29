class window.Buildings.BasicTower3 extends Buildings.Tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BasicTower3'
    @sprite.scale.set 2.0, 2.0
    @bullet = BasicBullet
    @controlledBullet = BasicBullet

    @name = 'BasicTower3'
    @range = 500
    @dps = 2000
    @fireRate = 200
    @bulletScale = 2.0
    
    @bulletStrength = @dps / (1000/@fireRate)
    @bulletSpeed = 10 * @range

    super(@game, @hex)
