class window.Buildings.BasicTower2 extends Buildings.Tower
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BasicTower1'
    @sprite.scale.set 1.5, 1.5
    @bullet = BasicBullet
    @controlledBullet = BasicBullet

    @name = 'BasicTower2'
    @range = 300
    @dps = 600
    @fireRate = 400
    @bulletScale = 0.75
    
    @bulletStrength = @dps / (1000/@fireRate)
    @bulletSpeed = 10 * @range
    
    super(@game, @hex)
