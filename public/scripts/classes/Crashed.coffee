class window.Crashed extends EventEmitter
  constructor: () ->
    # super
    @level = 0
    @gold = 100
    @buildMode = true
    @phase = 'build'
    gridSize = 14
    tileSize = 80

    @prices =
      collector: { food: 1, gold: 10 }
      farm: { food: -3, gold: 10 }
      road: { food: 0, gold: 4 }
      wall: { food: 0, gold: 2 }
      tower: { food: 1, gold: 10 }

    @buildingValidator = new BuildingValidator()
    @selected  = new SelectionList()
    @hexGrid   = new HexGrid gridSize, tileSize, @hexGridGenerator
    @enemies   = new EnemyContainer(@changeGold, @onEnemyDeath)
    @buildings = new BuildingContainer @changeGold
    
    stage.addChild @hexGrid
    @hexGrid.addChild @buildings
    @hexGrid.addChild @enemies

  start: () =>
    @buildings.add 'base', [@hexGrid.getHex(0,0)]
    @hexGrid.setDraggable true
    @updateInfo()
    $( "#ui" ).show()
    @buildPhase()
    @

  build: (type) =>
    res = @buildingValidator.canBuild type, @
    if res is true
      @gold -= @prices[type].gold * @selected.length
      @buildings.add type, @selected
      @updateTextures() if type is 'wall'
      @updateInfo()
    else alert res
    @selected.clear()
    
  sell: () ->
    res = @buildingValidator.canSell @selected
    toSell = @selected.filter (h) -> h.wall? or h.building?
    if res is true
      for h in toSell
        b = h.wall or h.building
        console.log b
        @gold += @prices[b.type].gold * toSell.length // 2
        @buildings.remove toSell
      @updateTextures()
      @updateInfo()
    else alert res
    @selected.clear()

  updateTextures: () ->
    b.updateTexture() for b in @buildings.get('wall')
    null

  #Generate a Hex Map
  hexGridGenerator: (q, r) ->
    building = null
    gold = 0
    type = ''
    emptySpaces = [-1,0,1]
    if q in emptySpaces and r in emptySpaces
      type = ''
    else
      randEnviron = Math.random()
      if randEnviron < 0.075
        type = 'rocks'
      else if randEnviron < 0.15
        type = 'trees'
      else
        if Math.random() < .2 then gold = 100
    { type, gold }

  getFood: () => @buildings.get().reduce ( (s, b) -> s - b.foodCost ), 0
  # getGold: () => @gold

  changeGold: (n) =>
    @gold += n
    @updateInfo()

  #Update called in main update loop.
  update: () ->
    if @phase is 'fight'
      b.act() for b in @buildings.get()
    true

  enemiesPerLevel : (n) ->
    n ?= @level
    n = Math.floor(10 * Math.pow(1.15, n))
    small = 36
    large = small//36
    { small, large, total: small+large }
  
  onEnemyDeath: (enemy) ->
    @changeGold 1
    numEnemies = @enemiesPerLevel().total
    if @enemies.count() == 1
      game.buildPhase()
    else
      value = @enemies.count() * 100 / numEnemies
      $('#progressbar').progressbar { value }
      $( ".progress-label" ).text @enemies.count()

  buildPhase: () ->
    @phase = 'build'
    @level++
    @buildings.each (b) ->
      b.onEndRound() if b.onEndRound
    $('#leveltext').text('Level: '+@level)
    $('#start').show()
    $('#buildmenu,#sellbutton').show()
    $('#progressbar').hide()

  fightPhase: () ->
    @phase = 'fight'
    $('#buildmenu,#sellbutton').hide()
    $('#start').hide()
    $('#progressbar').progressbar({ value: 100 }).show()

    outerHexes = @hexGrid.getOuterRing()
    numEnemies = @enemiesPerLevel().total
    $('.progress-label').text numEnemies
    
    @enemies.generate @enemiesPerLevel(), (() -> random(outerHexes))

  updateInfo: () ->
    $('#goldtext').text('Gold: '+@gold)
    $('#foodtext').text('Food: '+@getFood())
    $('#leveltext').text 'Level: '+@level
  