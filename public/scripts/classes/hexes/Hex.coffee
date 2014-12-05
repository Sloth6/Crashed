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
      @alpha = .5
      game.selected.add @
    else
      @selected = false
      @alpha = 1.0
      game.selected.remove @
  
  hasBuilding: () => @building?

  # cost for unit to traverse, used in astar
  isRocks: () -> false
  
  isTrees: () -> false
  
  getCost: () =>
    if @isTrees() then 10 else 1.0
  
  isWall: () -> @wall

  #I don't really know what the question mark syntax is. Did I use it right?
  isBuildable: () -> not (@isWall() or @isTrees() or @isRocks() or @building)

  neighbors: () ->
    ([[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, 1]].map ([q, r]) =>
      game.hexGrid.getHex q+@q, r+@r).filter((elem) -> !!elem)
  
  distanceTo: ({ q, r }) ->
    (Math.abs(q - @q) + Math.abs(r - @r) + Math.abs(q + r - @q - @r)) / 2
  
  addBuilding: (@building) =>
  addWall: (@wall) =>
  
  addTo: (container) ->
    container.addChild @
    container.addChild @environmentSprite if @environmentSprite
    container.addChild @goldSprite if @goldSprite
    container.addChild @text if @text
