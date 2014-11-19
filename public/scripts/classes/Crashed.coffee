class Crashed
  constructor: ({ level, gold, prices, @gridSize, @tileSize }) ->
    @level ?= 0
    @gold ?= 0
    @prices ?=
      tower : 10
      collector : 10
      wall : 10
      pylon : 10
    @buildings = []
    # @enemies = []
    @selected = []
    @buildMode = true
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
    @hexGrid = new HexGrid @gridSize, @tileSize, (q, r) ->
      building = null
      if q == 0 and r == 0
        building = 'base'
      else if (q == -1 and r == 0) or (q == 0 and r == -1)
        building = 'collector'
      else if q not in [-1,0,1] or r not in [-1,0,1]
        randEnviron = Math.random() # [0, 1)
        if randEnviron < .1
          environment = 'rocks'+Math.randInt(3)
        else if randEnviron < .2
          environment = 'trees'+Math.randInt(3)
        # environment = 'rocks0'
      gold = 0
      {building, environment, gold}

    # @hexGrid.getHex(0,0).build('base')

    # distance function for KD tree. Takes from Hex class
    distance = (a,b) -> Hex::distanceTo.apply a, b
    # console.log Hex.distanceTo
    @enemyKdTree = new kdTree [], distance, ['q', 'r']
    #KD tree crashes on empty query because it sucks. Insert unreachable root.
    @enemyKdTree.insert { q: 100000, r: 100000 }
    window.foobar = { q: 0, r: 0 }
    @enemyKdTree.insert foobar
  
    $('#leveltext').text('Level: '+@level)
    $('#goldtext').text('Gold: '+@gold)

  update: () ->
    @buildings.forEach (building) -> building.act()
    # @enemies.forEach (building) -> building.act()

  enemiesPerLevel : (n) ->
    Math.floor(10 * Math.pow(1.2, n))
    # { s : 100 * n, l : 100 * n }
  
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

  buildPhase: () ->
    @level++
    $('#leveltext').text('Level: '+@level)
    $('#start').show()
    $('#progressbar').hide()

  fightPhase: () ->
    $('#start').hide()
    $('#progressbar').progressbar({ value: 100 }).show()

    outerHexes = @hexGrid.getOuterRing()
    numEnemies = @enemiesPerLevel(@level)
    $('.progress-label').text(numEnemies)

    for i in [0...numEnemies] by 1
      hex = random outerHexes
      enemy = new Enemy({
        q: hex.q
        r: hex.r
        health: 500
        speed: 2000 * (Math.random()/2 + 0.5)
      }).onMove(() ->
        # game.enemyKdTree.remove @
        hex = game.hexGrid.getHex @q, @r
        if hex.building?
          hex.building.destroy()
      ).onDeath(() =>
        game.gold += 1
        if @enemyContainer.children.length == 1
          game.buildPhase()
        else
          value = @enemyContainer.children.length * 100 / numEnemies
          # console.log value
          $('#progressbar').progressbar({ value })
          $( ".progress-label" ).text(@enemyContainer.children.length)
      ).addTo game.enemyContainer

window.Crashed = Crashed
