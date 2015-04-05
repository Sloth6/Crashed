class Wall extends Building
  constructor: ( hex ) ->
    super hex, 'wall'
    @removeChildren()
    @sprites = {}
    for pos, texture of textures.walls
      s = new PIXI.Sprite texture
      s.anchor = new PIXI.Point 0.5, 0.5
      @sprites[pos] = s
      @addChild s
  updateTexture: () ->
    dirs = ['bottomRight', 'topRight', 'top', 'topLeft', 'bottomLeft', 'bottom']
    # @wallContainer.children.sort (a, b) =>
    #   if a.hex.q < b.hex.q or a.hex.r < b.hex.r
    #     return -1
    #   else if a.hex.q > b.hex.q or a.hex.r > b.hex.r
    #     return 1
    for n, i in @hex.neighbors()
      dir = dirs[i]
      @sprites[dir].visible = !n.isWall()
    true

  sell: () =>
    @hex.wall = null
    game.enemies.each (e) -> e.recalculatePath = true
    super()
    
  destroy: () =>
    @hex.wall = null
    game.enemies.each (e) -> e.recalculatePath = true
    super()