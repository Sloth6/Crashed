class window.Crashed
  constructor: ({ @gold, @prices, @gridSize, @tileSize }) ->
    #Game Variables
    @level = 0

    @buildings = []
    @selected = []
    @buildMode = true

    #Layers, so hexes on bottom, buildings above and enemeies on top
    @viewContainer = new DraggableContainer()
    @viewContainer.x = window.innerWidth/2
    @viewContainer.y = window.innerHeight/2
    @enemyContainer = new PIXI.DisplayObjectContainer()
    @enemyContainer.x = window.innerWidth/2
    @enemyContainer.y = window.innerHeight/2
    @buildingContainer = new PIXI.DisplayObjectContainer()
    @enemyContainer.x = window.innerWidth/2
    @enemyContainer.y = window.innerHeight/2

    #Datastructures
    console.time 'generateGrid'
    @hexGrid = new HexGrid @gridSize, @tileSize, @hexGridGenerator
    console.timeEnd 'generateGrid'
    gridRoot = [{ q: 100000, r: 100000 }]
    distanceFun = (a,b) -> Hex::distanceTo.call a, b
    @enemyKdTree = new kdTree gridRoot, distanceFun, ['q', 'r']
  
    #UI
    $('#leveltext').text('Level: '+@level)
    $('#goldtext').text('Gold: '+@gold)

  #Generate a Hex Map
  hexGridGenerator: (q, r) ->
    building = null
    gold = 0
    type = ''
    building = null

    building = 'base' if q == 0 and r == 0
    
    emptySpaces = [-1,0,1]#, @gridSize, -@gridSize]
    if q in emptySpaces or r in emptySpaces
      type = ''
    else
      randEnviron = Math.random() # [0, 1)
      if randEnviron < 0.075
        type = 'rocks'
      else if randEnviron < 0.15
        type = 'trees'
      else
        if Math.random() < .2 then gold = 100
    
    { building, type, gold }

  addGold: (n) ->
    @gold += n
    $('#goldtext').text('Gold: '+@gold)

  #Update called in main update loop. 
  update: () ->
    @buildings.forEach (building) -> building.act()
    # @enemies.forEach (building) -> building.act()

  enemiesPerLevel : (n) ->
    n = Math.floor(10 * Math.pow(1.15, n))
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
    @addGold 1
    numEnemies = @enemiesPerLevel(@level).total
    if @enemyContainer.children.length == 1
      game.buildPhase()
    else
      value = @enemyContainer.children.length * 100 / numEnemies
      $('#progressbar').progressbar({ value })
      $( ".progress-label" ).text(@enemyContainer.children.length)

  buildPhase: () ->
    @level++
    @getBuildings().forEach (b) -> 
      b.onEndRound() if b.onEndRound
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

  build: (type) ->
    if @canBuild type
      @selected.forEach (hex) ->
        building = hex.build type
        game.buildings.push building if building
        hex.selected = false
        hex.sprite.alpha = 1.0
      game.selected = []

  canBuild: (type) ->
    #check price
    totalCost = @selected.length * @prices[type]
    if totalCost > @gold
      alert "Cannot afford #{@selected.length} #{type}s. Costs #{totalCost}g."
      return false
    if type == 'wall' #ensure we don't wall off completly.
      start = game.hexGrid.getOuterRing()[0]
      end = game.hexGrid.getHex 0, 0
      @selected.forEach (h) -> h.wall = true
      if astar.search(game.hexGrid, start, end).length == 0
        @selected.forEach (h) -> h.wall = null
        alert "Cannot completely wall off base"
        return false
    else #ensure everything is connected
      return true
    true

