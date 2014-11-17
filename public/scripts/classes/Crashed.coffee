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
    # @enemies = []
    @selected = []

    #create layers, so hexes on bottom, buildings above and enemeies on top
    @viewContainer = new DraggableContainer()
    @enemyContainer = new PIXI.DisplayObjectContainer()
    @enemyContainer.x = window.innerWidth/2
    @enemyContainer.y = window.innerHeight/2
    @buildingContainer = new PIXI.DisplayObjectContainer()
    @enemyContainer.x = window.innerWidth/2
    @enemyContainer.y = window.innerHeight/2

    #data structures
    @hexGrid = new HexGrid @gridSize, @tileSize
    # distance function for KD tree. Takes from Hex class
    distance = (a,b) -> Hex::distanceTo.apply a, b
    # console.log Hex.distanceTo
    @enemyKdTree = new kdTree [], distance, ['q', 'r'] 
    #KD tree crashes on empty query because it sucks. Insert unreachable root.
    @enemyKdTree.insert { q: 100000, r: 100000 }

  update: () ->
    @buildings.forEach (building) -> building.act()
    # @enemies.forEach (building) -> building.act()

  # enemiePerLevel : (n) ->
  #   { s : 100 * n, l : 100 * n }
  
  nearestEnemy: (qr, distance = 1000) ->
    q = @enemyKdTree.nearest qr, 1, distance
    if q.length > 0
      {enemy: q[0][0], distance: q[0][1]}
    else {enemy: null, distance: null}

  addTo : (scene) ->
    @hexGrid.addTo @viewContainer
    @viewContainer.addChild @buildingContainer
    @viewContainer.addChild @enemyContainer
    @viewContainer.addTo scene
  

  run: () ->
    outerHexes = @hexGrid.getOuterRing()
    setInterval (() ->
      hex = random outerHexes
      enemy = new Enemy({ 
        q: hex.q
        r: hex.r
        health: 300
        speed: 2000
      }).onMove(() ->
        hex = game.hexGrid.getHex @q, @r
        if hex.building?
          hex.building.destroy()
      ).onDeath(() =>
        game.gold += 1
      ).addTo game.enemyContainer
    ), 500

window.Crashed = Crashed