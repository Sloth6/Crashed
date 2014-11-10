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
    @enemyKdTree.insert { q: Infinity, r: Infinity }
  update: () ->
    @buildings.forEach (building) -> building.act()
    @enemies.forEach (building) -> building.act()

  # enemiePerLevel : (n) ->
  #   { s : 100 * n, l : 100 * n }
  nearestEnemy: (qr, distance = 100000) ->
    q = @enemyKdTree.nearest qr, 1, distance
    if q.length > 0
      {enemy: q[0][0], distance: q[0][1]}
    else {enemy: null, distance: null}

  run: () ->
    setInterval (() ->
      enemy = new Enemy({ 
        q: -4
        r: Math.randomInt 0, 4
        health: 300
        speed: 5000
      }).addTo game.hexGrid.container
    ), 1000

window.Crashed = Crashed