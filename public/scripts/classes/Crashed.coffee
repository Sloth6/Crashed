class window.Crashed
  constructor: ({ @gold, @prices, @gridSize, @tileSize }) ->
    #Game Variables
    console.log @gold
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
    @enemies = []
    
    #UI
    $('#leveltext').text('Level: '+@level)
    $('#goldtext').text('Gold: '+@gold)
    $('#foodtext').text('Food: '+@getFood())

  start: () ->
    console.log 'This voyage has begun!'
    @hexGrid.getHex(0,0).build 'base'
    @viewContainer.setDraggable true
    $( "#ui" ).show()

  enemyCount: () ->
    countR = (n) ->
      return 0 if n is null
      return 1 + countR(n.left) + countR(n.right)
    countR(@enemyKdTree.root) - 1

  #Generate a Hex Map
  hexGridGenerator: (q, r) ->
    building = null
    gold = 0
    type = ''
    building = null

    building = 'base' if q == 0 and r == 0
    
    emptySpaces = [-1,0,1]#, @gridSize, -@gridSize]
    if q in emptySpaces and r in emptySpaces
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

  getFood: () ->
    @buildings.reduce ((s, b) ->
      if b instanceof buildings.farm
        f = 3
      else if b instanceof buildings.wall
        f = 0
      else
        f = -1
      s + f), 0

  addGold: (n) ->
    @gold += n
    $('#goldtext').text('Gold: '+@gold)

  #Update called in main update loop. 
  update: () ->
    @buildings.forEach (building) -> building.act()
    # @enemies.forEach (building) -> building.act()

  enemiesPerLevel : (n) ->
    n = Math.floor(10 * Math.pow(1.15, n))
    small = 36
    large = small//4
    { small, large, total: small+large }

  nearestEnemy: (qr) ->
    e = @enemyKdTree.nearest qr, 1
    if e.length > 0 and e[0][0].q != 100000 then e[0][0] else null

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

  updateInfo: () ->
    $('#goldtext').text('Gold: '+@gold)
    $('#foodtext').text('Food: '+@getFood())

  sell: () ->
    @selected.forEach (hex) =>
      if (hex.q | hex.r) == 0
        return alert "You really don't want to sell that.."
      index = @buildings.indexOf hex.building
      @buildings.splice index, 1
      hex.building.sell()
    @updateInfo()

  build: (type) ->
    if @canBuild type
      @selected.forEach (hex) ->
        building = hex.build type
        game.buildings.push building if building
        hex.selected = false
        hex.sprite.alpha = 1.0
      game.selected = []
      @updateInfo()

  canBuild: (type) ->
    #check price
    totalCost = @selected.length * @prices[type]
    if totalCost > @gold
      alert "Cannot afford #{@selected.length} #{type}s. Costs #{totalCost}g."
      return false
    if (@getFood() - @selected.length < 0) and not (type in ['farm', 'wall'])
      alert "Not enough food. Build more farms."
      return false
    if type == 'wall' #ensure we don't wall off completly.
      start = game.hexGrid.getOuterRing()[0]
      end = game.hexGrid.getHex 0, 0
      options = { impassable: (h) => h.isWall() or h in @selected }
      if astar.search(game.hexGrid, start, end, options).length == 0
        alert "Cannot completely wall off base"
        return false
    else #ensure everything is connected
      return true
    true

