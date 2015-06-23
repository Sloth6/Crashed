class window.Road extends Building
  @cost = 2
  @upgrades = []
  constructor: (@game, @hex) ->
    # View
    @sprite = @game.buildingGroup.create @hex.x, @hex.y, 'Road'
    
    # State
    @health = 100
    @name = 'Road'
    @r = 35
    super()

  kill : () ->
    @game.map_changed = true
    super()