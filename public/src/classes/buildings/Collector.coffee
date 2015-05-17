class window.Collector extends Building
  @cost = 10
  @income = 4
  @upgrades = []
  constructor: (@game, @hex) ->
    # View
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'Collector'
    
    # State
    @health = 5
    @r = 5
    @name = 'Collector'
    super()

  destroy : () ->
    @game.map_changed = true
    super()