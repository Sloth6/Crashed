class Crashed
  constructor: ({ level, gold, prices, gridSize, tileSize }) ->
    @level ?= 0
    @gold ?= gold
    @prices ?= 
      tower : 10
      collector : 10
      wall : 10
      pylon : 10
    @buildings = []
    @enemies = []
    @selected = []
    @hexGrid = new window.HexGrid gridSize, tileSize

  update : () ->
    @buildings.forEach (building) -> building.act()
    @enemies.forEach (building) -> building.act()

  enemiePerLevel : (n) ->
    { s : 100 * n, l : 100 * n }

window.Crashed = Crashed