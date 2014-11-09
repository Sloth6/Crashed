class Crashed
  constructor: ({ level, gold, prices, @gridSize, @tileSize }) ->
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

    #data structures
    @hexGrid = new HexGrid @gridSize, @tileSize

    distance = (a, b) ->
      (Math.abs(a.q - b.q) + Math.abs(a.r - b.r) + Math.abs(a.q + a.r - b.q - b.r)) / 2
    @enemyKdTree = new kdTree [], distance, ['q', 'r'] 
  
  update: () ->
    @buildings.forEach (building) -> building.act()
    @enemies.forEach (building) -> building.act()

  # enemiePerLevel : (n) ->
  #   { s : 100 * n, l : 100 * n }
  nearestEnemy: (qr, distance = 100000000) ->
    @enemyKdTree.nearest qr, 1, distance

  run: () ->
    setInterval (() ->
      enemy = new Enemy { q: -4, r: Math.randomInt(0, 4) }
        .addTo game.hexGrid.container
        .onDeath () ->
          game.enemyKdTree.remove @
        .onMove () -> 
          game.enemyKdTree.remove @
          game.enemyKdTree.insert @
    ), 1000

window.Crashed = Crashed