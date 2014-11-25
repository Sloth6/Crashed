class Unit
  constructor: ({ @q, @r, @health, @speed, texture }) ->
    hex = game.hexGrid.getHex @q, @r
    @alive = true
    @sprite = new PIXI.Sprite texture
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = hex.x
    @sprite.position.y = hex.y
    @sprite.width = hex.sprite.width/4
    @sprite.height = hex.sprite.height/2
    @sprite.unit = @
    
  moveTo: ({ q, r }, done) ->
    start = game.hexGrid.getHex @q, @r
    end = game.hexGrid.getHex q, r

    options =
      impassable: (h) ->  
        (h.isWall() and not (@ instanceof LargeBlob)) or h.isRocks()
    @path = astar.search game.hexGrid, start, end, options

    moveR = (path, unit) ->
      if path.length == 0
        if done then return done() else return
      next = path.shift()
      new TWEEN.Tween unit.sprite.position
        .to {
          x: next.x + Math.randInt(-20,20)
          y: next.y + Math.randInt(-20,20)
        }, unit.speed
        .easing TWEEN.Easing.Quintic.InOut
        .onComplete () ->
          unit.q = next.q
          unit.r = next.r
          game.enemyKdTree.remove unit
          if unit.health > 0
            game.enemyKdTree.insert unit
            unit.onMove(game.hexGrid.getHex unit.q, unit.r) if unit.onMove
            moveR path, unit
        .start()
    moveR @path, @

  hurt: (h) ->
    @health -= h
    @kill() if @health <= 0

  kill: () ->
    console.trace()
    @sprite.parent.removeChild @sprite
    @path = null
    @sprite = null
    @alive = false

  addTo: (container) =>
    container.addChild @sprite

window.Unit = Unit
