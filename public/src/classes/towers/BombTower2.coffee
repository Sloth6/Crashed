class window.BombTower2 extends Tower
  @cost = 100
  @upgrades = []
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'BombTower2'
    @sprite.scale.set 1.5, 1.5
    @bullet = BombBullet
    @controlledBullet = BombBullet

    @name = 'BombTower2'
    @range = 300
    @dps = 4000 / 3 #DPS is the same as basicTower 2 when we hit 5 enemies.
    @fireRate = 1000

    @bulletStrength = @dps / (1000/@fireRate)
    @bulletSpeed = 10 * @range

    super(@game, @hex)
