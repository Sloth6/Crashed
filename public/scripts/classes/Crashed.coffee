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
    @viewContainer.pivot = new PIXI.Point @viewContainer.x, @viewContainer.y
    
    @enemyContainer = new PIXI.DisplayObjectContainer()
    @enemyContainer.x = window.innerWidth/2
    @enemyContainer.y = window.innerHeight/2
    
    @buildingContainer = new PIXI.DisplayObjectContainer()
    @buildingContainer.x = window.innerWidth/2
    @buildingContainer.y = window.innerHeight/2

    @wallContainer = new PIXI.DisplayObjectContainer()
    @wallContainer.x = window.innerWidth/2
    @wallContainer.y = window.innerHeight/2

    #Datastructures
    console.time 'generateGrid'
    @hexGrid = new HexGrid @gridSize, @tileSize, @hexGridGenerator
    console.timeEnd 'generateGrid'
    # gridRoot = [{ q: 100000, r: 100000 }]
    # distanceFun = (a,b) -> Hex::distanceTo.call a, b
    # @enemyKdTree = new kdTree gridRoot, distanceFun, ['q', 'r']
    @enemies = []
    
    #UI
    @updateInfo

    @viewContainer.addChild @hexGrid
    @viewContainer.addChild @buildingContainer
    @viewContainer.addChild @wallContainer
    @viewContainer.addChild @enemyContainer
    stage.addChild @viewContainer

  start: () =>
    console.log 'This voyage has begun!'
    @buildings.push @hexGrid.getHex(0,0).build('base')
    @viewContainer.setDraggable true
    $( "#ui" ).show()

  enemyCount: () ->
    enemies.reduce ((s, e) -> s += if e.alive then 1 else 0), 0
    # @enemies.length
    # countR = (n) ->
    #   return 0 if n is null
    #   return 1 + countR(n.left) + countR(n.right)
    # countR(@enemyKdTree.root) - 1

  #Generate a Hex Map
  hexGridGenerator: (q, r) ->
    building = null
    gold = 0
    type = ''
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
    
    { type, gold }

  getFood: () ->
    @buildings.reduce ( (s, b) -> s - b.foodCost ), 0

  addGold: (n) =>
    @gold += n
    @updateInfo()

  #Update called in main update loop. 
  update: () ->
    @buildings.forEach (building) -> building.act()
    # @enemies.forEach (building) -> building.act()

  enemiesPerLevel : (n) ->
    n = Math.floor(10 * Math.pow(1.15, n))
    small = 36
    large = small//36
    { small, large, total: small+large }

  nearestEnemy: (qr, r) ->
    dist = (a) -> Hex::distanceTo.call a, qr
    nearest = null
    minDist = Infinity
    for enemy in @enemies
      d = dist enemy
      if enemy? and enemy.alive and d <= r and d < minDist
        nearest = enemy
        minDist = d
    nearest

    # e = @enemyKdTree.nearest qr, 1
    # if e.length > 0 and e[0][0].q != 100000 then e[0][0] else null
  
  getBuildings: () -> @buildings
  
  getEnemyUnits: () -> @enemyContainer.children.map (sprite) -> sprite.unit

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
    $('#buildmenu,#sellbutton').show()
    $('#progressbar').hide()

  fightPhase: () ->
    @enemies = []
    $('#buildmenu,#sellbutton').hide()
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
    $('#leveltext').text 'Level: '+@level

  sell: () ->
    @selected.forEach (hex) =>
      if (hex.q | hex.r) == 0
        return alert "You really don't want to sell that.."
      index = @buildings.indexOf hex.building
      @buildings.splice index, 1
      hex.building?.sell()
      hex.wall?.sell()
      hex.selected = false
      hex.alpha = 1.0
    game.selected = []
    @updateInfo()

  updateWallTextures: () ->
    dirs = ['bottomRight', 'topRight', 'top', 'topLeft', 'bottomLeft', 'bottom']
    @wallContainer.children.sort (a, b) =>
      if a.hex.q < b.hex.q or a.hex.r < b.hex.r
        return -1
      else if a.hex.q > b.hex.q or a.hex.r > b.hex.r
        return 1
    for b in @buildings
      continue unless b.hex.isWall()
      b.hex
      for n, i in b.hex.neighbors()
        continue unless n.isWall()
        dir = dirs[i]
        b.sprites[dir].visible = false

  build: (type) ->
    if @canBuild type
      @selected.forEach (hex) ->
        building = hex.build type
        game.buildings.push building if building
        hex.selected = false
        hex.alpha = 1.0
      game.selected = []
      @updateWallTextures()
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
    
    if @selected.some((h) -> h.building? or h.wall?)
      alert 'Sell that building first!'
      return false

    if type == 'wall' #ensure we don't wall off completly.
      start = game.hexGrid.getOuterRing()[0]
      end = game.hexGrid.getHex 0, 0
      options = { impassable: (h) => h.isWall() or h.isRocks() or h in @selected }
      if astar.search(game.hexGrid, start, end, options).length == 0
        alert "Cannot completely wall off base"
        return false
    else # only applies to non-walls
      # Treat each building as 'true' which allows us to run a simple 
      # algorithm checking if each building is connected without actually
      # creating and destroying each building
      @selected.forEach (h) -> h.building = true
      isConnected = @isConnected()
      @selected.forEach (h) -> h.building = null
      if not isConnected
        alert "Buildings (not walls) must be adjacent to another building."
        return false
    true

  isConnected: () ->
    numSeen = 0
    seen = {}
    # recursively check all neighbors
    checkR = (h) ->
      return if not h.hasBuilding()
      return if seen[h.q+':'+h.r]?
      #record all the buildings we reach from the center.
      seen[h.q+':'+h.r] = true
      numSeen++
      h.neighbors().forEach checkR

    checkR @hexGrid.getHex(0,0)
    # ensure we see every buildings thbat will be built.
    numBuildings = @buildings.filter((b) -> !(b instanceof buildings.wall)).length
    numSeen == numBuildings + @selected.length