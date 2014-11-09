class Enemy
  constructor: ({ @q, @r, @type, @health, @speed }) ->
    @generatePath()
    hex = game.hexGrid.getHex @q, @r
    @sprite = new PIXI.Sprite textures.enemy
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = hex.x
    @sprite.position.y = hex.y
    @sprite.width = 2 * hex.size
    @sprite.height = hex.size * Math.sqrt 3
    @interval = setInterval @move, 1000
    # @move()
  
  generatePath: () ->
    start = game.hexGrid.getHex @q, @r
    end = game.hexGrid.getHex 0, 0
    @path = astar.search game.hexGrid, start, end

  move: () =>
    if @path.length > 0
      (new TWEEN.Tween( @sprite.position ))
        .to(@path[0], 1000 )
        .onComplete(
          () => @path.shift()
          # @move()
        ).start()

      # @sprite.position.x = @path[0].x
      # @sprite.position.y = @path[0].y
      # @path.shift()
    else
      clearInterval @interval

  addTo: (container) =>
    container.addChild @sprite

window.Enemy = Enemy