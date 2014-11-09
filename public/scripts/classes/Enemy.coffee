class Enemy
  constructor: ({ @q, @r, @type, @health, @speed }) ->
    @speed ?= 3000
    
    hex = game.hexGrid.getHex @q, @r

    @sprite = new PIXI.Sprite textures.enemy
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = hex.x
    @sprite.position.y = hex.y
    @sprite.width = hex.size/2 
    @sprite.height = (hex.size * Math.sqrt 3) /4
    
    @generatePath()
    @move()
  
  generatePath: () ->
    start = game.hexGrid.getHex @q, @r
    end = game.hexGrid.getHex 0, 0
    @path = astar.search game.hexGrid, start, end
    @

  move: () =>
    if @path.length > 0
      goTo = @path.shift()
      # goTo.x += Math.randomInt -5, 5
      # goTo.y += Math.randomInt -5, 5
      new TWEEN.Tween @sprite.position
        .to goTo, @speed
        .easing(TWEEN.Easing.Quintic.InOut)
        .onComplete () =>
          @onMoveFun() if @onMove
          @move()
        .start()
    else
      @kill()
    @
      # @sprite.position.x = @path[0].x
      # @sprite.position.y = @path[0].y
      # @path.shift()
    # else
    #   clearInterval @interval
  kill: () ->
    @onDeathFun() if @onDeath?
    @sprite.parent.removeChild @.sprite

  onMove: (@onMoveFun) -> @
  onDeath: (@onDeathFun) -> @

  addTo: (container) =>
    container.addChild @sprite
    @

window.Enemy = Enemy