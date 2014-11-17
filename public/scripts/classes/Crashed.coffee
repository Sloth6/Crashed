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
    @viewContainer.x = window.innerWidth/2
    @viewContainer.y = window.innerHeight/2

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
    window.foobar = { q: 0, r: 0 }
    @enemyKdTree.insert foobar
  
  update: () ->
    @buildings.forEach (building) -> building.act()
    # @enemies.forEach (building) -> building.act()

  # enemiePerLevel : (n) ->
  #   { s : 100 * n, l : 100 * n }
  
  nearestEnemy: (qr) ->
    q = @enemyKdTree.nearest qr, 1
    if q.length > 0
      q[0][0]
    else
      null

  addTo : (scene) ->
    @hexGrid.addTo @viewContainer
    @viewContainer.addChild @buildingContainer
    @viewContainer.addChild @enemyContainer
    @viewContainer.addTo scene
  
  getBuildings: () -> @buildings
  getEnemyUnits: () -> @enemyContainer.children.map (sprite) -> sprite.unit

  updateEnemyPaths: () ->
    @getEnemyUnits().forEach (unit) ->
      unit.moveTo { q: 0, r: 0 }

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
        # game.enemyKdTree.remove @
        hex = game.hexGrid.getHex @q, @r
        if hex.building?
          hex.building.destroy()
      ).onDeath(() =>
        game.gold += 1
      ).addTo game.enemyContainer
      # gage.enemyKdTree.insert enemy
    ), 500

window.Crashed = Crashed