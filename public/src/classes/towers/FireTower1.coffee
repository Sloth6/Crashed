class window.FireTower1 extends Tower
  @cost = 100
  @upgrades = []
  constructor: (@game, @hex) ->
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'FireTower1'
    @bullet = FireBullet
    @controlledBullet = FireBullet

    @name = 'FireTower1'
    @range = 300
    @fireRate = 2500
    @bulletSpeed = 500
    @bulletStrength = 5
    super(@game, @hex)
