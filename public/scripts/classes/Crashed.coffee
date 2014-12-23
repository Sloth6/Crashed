class window.Crashed extends EventEmitter
  constructor: () ->
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
    @hexGrid   = new HexGrid gridSize, tileSize
    @enemies   = new EnemyContainer()
    @buildings = new BuildingContainer()
    
    stage.addChild @hexGrid
    @hexGrid.addChild @buildings
    @hexGrid.addChild @enemies

    @addListener 'buildPhase', () =>
      @phase = 'build'
      @level++
      @buildings.each (b) -> b.onEndRound() if b.onEndRound

    @addListener 'build', (type) =>
      if @buildingValidator.canBuild type, @
        @changeGold(-@prices[type].gold * @selected.length)
        @buildings.add type, @selected
        @emit 'resourceChange'
      @selected.clear()

    @addListener 'sell', () =>
      toSell = @selected.filter (h) -> h.wall? or h.building?
      if @buildingValidator.canSell @selected
        for h in toSell
          b = h.wall or h.building
          @changeGold @prices[b.type].gold
        @buildings.remove toSell
        @emit 'resourceChange'
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
    $( "#ui" ).show()
    @emit 'buildPhase'
    @

  getFood: () => @buildings.get().reduce ( (s, b) -> s - b.foodCost ), 0

  changeGold: (n) =>
    @gold += n
    @emit 'resourceChange'

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