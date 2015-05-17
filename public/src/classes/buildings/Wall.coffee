class window.Wall extends Building
  @cost = 2
  @upgrades = []
  constructor: (@game, @hex) ->
    # View
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'Wall'
    
    # State
    @health = 100
    @name = 'Wall'
    @r = 35
    super()

  kill : () ->
    @game.map_changed = true
    super()