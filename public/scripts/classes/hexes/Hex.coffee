class window.Hex extends Selectable
  constructor: ({ width, height, @q, @r, @gold }) ->
    @building = null
    @wall = null
    @gold ?= 0
    { x, y } = @qrToxy { @q, @r, width }

    @text = new PIXI.Text @q+':'+@r, { font:"12px Arial", fill:"black" }
    @text.x = x
    @text.y = y
    @text.anchor.x = 0.5
    @text.anchor.y = 0.5

    if @gold > 0
      @goldSprite = new PIXI.Sprite textures.resourcesFull
      @goldSprite.anchor = { x: 0.5, y: 0.5 }
      @goldSprite.position = { x, y }
    super { x, y, width, height, texture: textures.hex }
  
  qrToxy: ({q, r, width}) ->
    size = width/2
    x = q * size * 1.5
    y =  ((r * (Math.sqrt(3)*size) + (q * Math.sqrt(3)/2 * size))) * .5
    { x, y }
  
  onToggleSelect: () ->
    return if @isRocks() or @isTrees()
    if @selected
      @sprite.alpha = .5
      game.selected.push @
    else
      @sprite.alpha = 1.0
      index = game.selected.indexOf @
      game.selected.splice(index, 1)
  
  hasBuilding: () => @building?

  # cost for unit to traverse, used in astar
  isRocks: () -> false#@environment?.indexOf('rocks') >= 0
  
  isTrees: () -> false#@environment?.indexOf('trees') >= 0
  
  getCost: () -> 1#if @isTrees then 1.5 else 1.0
  
  isWall: () -> (@building instanceof buildings.wall) or @wall
  # isWall: () -> @wall? or @isRocks()

  #I don't really know what the question mark syntax is. Did I use it right?
  isBuildable: () -> not (@isWall() or @isTrees() or @isRocks() or @building)

  neighbors: () ->
    ([[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, 1]].map ([q, r]) =>
      game.hexGrid.getHex q+@q, r+@r).filter((elem) -> !!elem)
  
  distanceTo: ({ q, r }) ->
    (Math.abs(q - @q) + Math.abs(r - @r) + Math.abs(q + r - @q - @r)) / 2
  
  build: (type) ->
    @building.destroy() if @building
    @building = new buildings[type](@, type)
    @building.addTo @sprite.parent

    @building
  
  addTo: (container) ->
    container.addChild @sprite
    container.addChild @environmentSprite if @environmentSprite
    container.addChild @goldSprite if @goldSprite
    container.addChild @text if @text

# hex = new PIXI.Graphics()
# hex.beginFill 0xFF3300
# hex.lineStyle 2, 0x000000, 1

# angle = 0.0
# scale = 1.0
# points = []
# for i in [0...7] by 1
#   angle = 1 * Math.PI / 3 * i;
#   x_i = Math.round(x + size * Math.cos(angle))
#   y_i = Math.round(y + size * Math.sin(angle))
  # points.push x_i, y_i
  # if i == 0
  #   hex.moveTo x_i, scale * y_i
  # else
  #   hex.lineTo x_i, scale * y_i

# hex.endFill()
# hex.drawPolygon points

# @sprite.hitArea = new PIXI.Polygon points