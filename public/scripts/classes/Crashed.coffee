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

    @addListener 'buildPhase', () =>
      @phase = 'build'
      @level++
      @buildings.each (b) -> b.onEndRound() if b.onEndRound

    @addListener 'build', (type) =>
      res = @buildingValidator.canBuild type, @
      if res is true
        @gold -= @prices[type].gold * @selected.length
        @buildings.add type, @selected
        @updateTextures() if type is 'wall'
        @updateInfo()
      else alert res
      @selected.clear()

    @addListener 'sell', () =>
      # numBuildings = (game.selected.filter (h) -> h.building or h.wall).length
      # return alert 'Select buildings to sell.' if numBuildings == 0
      res = @buildingValidator.canSell @selected
      toSell = @selected.filter (h) -> h.wall? or h.building?
      if res is true
        for h in toSell
          b = h.wall or h.building
          @gold += @prices[b.type].gold * toSell.length // 2
          @buildings.remove toSell
        @updateTextures()
        @updateInfo()
      else alert res
      @selected.clear()

    @addListener 'enemyDeath', (enemy) =>
      @changeGold 1
      @emit 'buildPhase' if @enemies.count() is 1 

    @addListener 'fightPhase', () =>
      @phase = 'fight'
      outerHexes = @hexGrid.getOuterRing()
      @enemies.generate @enemiesPerLevel(), (() -> random(outerHexes))        

  start: () =>
    @buildings.add 'base', [@hexGrid.getHex(0,0)]
    @hexGrid.setDraggable true
    @updateInfo()
    $( "#ui" ).show()
    @emit 'buildPhase'
    @


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
  


  updateInfo: () ->
    $('#goldtext').text('Gold: '+@gold)
    $('#foodtext').text('Food: '+@getFood())
    $('#leveltext').text 'Level: '+@level
  