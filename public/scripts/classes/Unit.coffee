class Unit
  constructor: ({ @q, @r, @health, @speed, texture }) ->
    @hex = game.hexGrid.getHex @q, @r
    @alive = true
    @sprite = new PIXI.Sprite texture
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = @hex.x
    @sprite.position.y = @hex.y
    @sprite.width = @hex.sprite.width/4
    @sprite.height = @hex.sprite.height/2
    @sprite.unit = @
    game.enemyKdTree.insert @
    @recalculatePath = true
    
  moveTo: ({ q, r }, done) ->

    #sets up initial movement
    start = @hex
    end = game.hexGrid.getHex q, r
    options =
      impassable: (h) =>
        (h.isWall() and not (@ instanceof LargeBlob)) or h.isRocks()
    @path = astar.search game.hexGrid, start, end, options

    #moves recursively
    moveR = (path, unit) ->
      #recalculates paths if necessary
      if unit.recalculatePath
        unit.recalculatePath = false
        path = astar.search game.hexGrid, unit.hex, end, options
      #if finished calls the done function
      if path.length == 0
        if done then return done() else return
      #sets the unit to the next tile
      unit.hex = path.shift()
      new TWEEN.Tween unit.sprite.position
        .to {
          x: unit.hex.x + Math.randInt(-20,20)
          y: unit.hex.y + Math.randInt(-20,20)
        }, unit.speed
        .easing TWEEN.Easing.Quintic.InOut
        .onComplete () ->
          unit.q = unit.hex.q
          unit.r = unit.hex.r
          game.enemyKdTree.remove unit
          if unit.health > 0
            game.enemyKdTree.insert unit
            unit.onMove(unit.hex) if unit.onMove
            moveR path, unit
        .start()
    moveR @path, @

  hurt: (h) ->
    @health -= h
    @kill() if @health <= 0

  kill: () ->
    @sprite.parent.removeChild @sprite
    @path = null
    @sprite = null
    @alive = false

  addTo: (container) =>
    container.addChild @sprite

window.Unit = Unit
