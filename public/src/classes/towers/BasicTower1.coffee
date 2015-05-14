class window.BasicTower1 extends Tower
  @cost = 10
  @upgrades = [
    ['Basic Tower 2', ((game, hex) -> game.build hex, BasicTower2), BasicTower2.cost]
    ['Bomb Tower 1', ((game, hex) -> game.build hex BombTower2), BombTower2.cost]
]
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BasicTower1'
    @sprite.scale.set 1.0, 1.0
    @bullet = BasicBullet
    @controlledBullet = BasicBullet

    @name = 'BasicTower1'
    @range = 200
    @dps = 300
    @fireRate = 600
    @bulletScale = 1.0

    @bulletStrength = @dps / (1000/@fireRate)
    @bulletSpeed = 5 * @range
    
    super(@game, @hex)
