class Crashed
  constructor: ({ @gold, @prices, @gridSize, @tileSize }) ->
    @level = 0
    @gold ?= 0
    @prices ?= 
      tower : 10
      collector : 10
      wall : 10
      pylon : 10
    @buildings = []
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

    #Create Datasctructures
    @hexGrid = new HexGrid @gridSize, @tileSize, @hexGridGenerator
    gridRoot = [{ q: 100000, r: 100000 }]
    distanceFun = (a,b) -> Hex::distanceTo.call a, b
    @enemyKdTree = new kdTree gridRoot, distanceFun, ['q', 'r'] 
  
    #Update UI
    $('#leveltext').text('Level: '+@level)
    $('#goldtext').text('Gold: '+@gold)

  #Generate a Hex Map
  hexGridGenerator: (q, r) ->
    building = null
    if q == 0 and r == 0
      building = 'base'
    else if (q == -1 and r == 0) or (q == 0 and r == -1)
      building = 'collector'
    else if q not in [-1,0,1] or r not in [-1,0,1]
      randEnviron = Math.random() # [0, 1)
      if randEnviron < .1
        environment = 'rocks'+Math.randInt(3)
      else if randEnviron < .4
        environment = 'trees'+Math.randInt(3)
      # environment = 'rocks0'
    gold = 0
    {building, environment, gold}

  #Update called in main update loop. 
  update: () ->
    @buildings.forEach (building) -> building.act()
    # @enemies.forEach (building) -> building.act()

  enemiesPerLevel : (n) ->
    n = Math.floor(10 * Math.pow(1.2, n))
    small = n
    large = n//4
    { small, large, total: small+large }
    # { s : 100 * n, l : 100 * n }
  
  nearestEnemy: (qr) ->
    q = @enemyKdTree.nearest qr, 1
    if q.length > 0 then q[0][0] else null

  addTo : (scene) ->
    @hexGrid.addTo @viewContainer
    @viewContainer.addChild @buildingContainer
    @viewContainer.addChild @enemyContainer
    @viewContainer.addTo scene
  
  getBuildings: () -> @buildings
  getEnemyUnits: () -> @enemyContainer.children.map (sprite) -> sprite.unit

  # updateEnemyPaths: () ->
  #   @getEnemyUnits().forEach (unit) ->
  #     unit.moveTo { q: 0, r: 0 }
  onEnemyDeath: (enemy) ->
    game.gold += 1
    numEnemies = @enemiesPerLevel(@level).total
    if @enemyContainer.children.length == 1
      game.buildPhase()
    else
      value = @enemyContainer.children.length * 100 / numEnemies
      $('#progressbar').progressbar({ value })
      $( ".progress-label" ).text(@enemyContainer.children.length)

  buildPhase: () ->
    @level++
    $('#leveltext').text('Level: '+@level)
    $('#start').show()
    $('#progressbar').hide()

  fightPhase: () ->
    $('#start').hide()
    $('#progressbar').progressbar({ value: 100 }).show()

    outerHexes = @hexGrid.getOuterRing()
    numEnemies = @enemiesPerLevel @level
    $('.progress-label').text numEnemies.total

    for i in [0...numEnemies.small] by 1
      hex = random outerHexes
      new SmallBlob({ q: hex.q, r: hex.r }).addTo game.enemyContainer

    for i in [0...numEnemies.large] by 1
      hex = random outerHexes
      new LargeBlob({ q: hex.q, r: hex.r }).addTo game.enemyContainer

window.Crashed = Crashed