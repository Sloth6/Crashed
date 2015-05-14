class window.BombTower1 extends Tower
  @cost = 30
  @upgrades = [BombTower2, FireTower1]
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BombTower1'
    @bullet = BombBullet
    @controlledBullet = BombBullet

    @name = 'BombTower1'
    @range = 200
    @dps = 600 / 3 #DPS is the same as basicTower 2 when we hit 5 enemies.
    @fireRate = 2000


    @bulletStrength = @dps / (1000/@fireRate)
    @bulletSpeed = 10 * @range

    super(@game, @hex)