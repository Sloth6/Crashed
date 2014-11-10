class Unit
  constructor: ({ @q, @r, @health, @speed, texture }) ->
    hex = game.hexGrid.getHex @q, @r
    @alive = true
    @sprite = new PIXI.Sprite texture
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = hex.x
    @sprite.position.y = hex.y
    @sprite.width = hex.size/2 
    @sprite.height = (hex.size * Math.sqrt 3) /4
    
    game.enemyKdTree.insert @

  moveTo: ({ q, r }, done) ->
    start = game.hexGrid.getHex @q, @r
    end = game.hexGrid.getHex q, r
    @path = astar.search game.hexGrid, start, end

    moveR = (path, unit) ->
      if path.length == 0
        return done() if done
        return
      next = path.shift()
      new TWEEN.Tween unit.sprite.position
        .to next, unit.speed
        .easing TWEEN.Easing.Quintic.InOut
        .onComplete () ->
          unit.q = next.q
          unit.r = next.r
          game.enemyKdTree.remove unit
          if unit.health > 0
            unit.onMoveFun() if unit.onMoveFun
            game.enemyKdTree.insert unit
            moveR path, unit
        .start()

    moveR @path, @

  hurt: (h) ->
    @health -= h
    @onHit if @onHit
    @kill() if @health <= 0

  kill: () ->
    @onDeathFun() if @onDeathFun
    game.enemyKdTree.remove @
    @sprite.parent.removeChild @sprite

    @path = null
    @sprite = null
    @alive = false

  onMove: (@onMoveFun) -> @
  onDeath: (@onDeathFun) -> @
  onHit: (@onHitFun) -> @

  addTo: (container) =>
    container.addChild @sprite
    @

window.Unit = Unit