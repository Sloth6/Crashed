class Hex
  constructor: ({ @width, @height, @q, @r, @gold, @environment}) ->
    @selected = false
    @building = null
    @environment ?= null
    @gold ?= 0

    size = @width/2
    @x = @q * size * 1.5
    @y =  ((@r * (Math.sqrt(3)*size) + (@q * Math.sqrt(3)/2 * size))) * .5
    @text = new PIXI.Text @q+':'+@r, { font:"12px Arial", fill:"black" }
    @text.x = @x
    @text.y = @y
    @text.anchor.x = 0.5
    @text.anchor.y = 0.5
      
    if @environment
      @environmentSprite = new PIXI.Sprite textures[@environment]
      @environmentSprite.anchor.x = 0.5
      @environmentSprite.anchor.y = 0.5
      @environmentSprite.position.x = @x
      @environmentSprite.position.y = @y
      @environmentSprite.width = @width
      @environmentSprite.height = @height      
    
    @sprite = new PIXI.Sprite textures.hex
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = @x
    @sprite.position.y = @y
    @sprite.width = @width
    @sprite.height = @height
    @sprite.interactive = true

    clicked = false
    @sprite.mousedown = (data) =>
      clicked = true

    @sprite.mouseup = (data) =>
      @selected = !@selected if clicked
      @onToggleSelect() if clicked
      
    @sprite.mousemove = (data) =>
      clicked = false

  select: () ->
    @selected = !@selected
    @onToggleSelect()

  onToggleSelect: () ->
    # return if isRocks()
    if @selected 
      @sprite.alpha = .5
      game.selected.push @
    else 
      @sprite.alpha = 1.0
      index = game.selected.indexOf @
      game.selected.splice(index, 1);

  # cost for unit to traverse, used in astar
  isRocks: () -> @environment?.indexOf('rocks') >= 0
  isTrees: () -> @environment?.indexOf('trees') >= 0
  getCost: () -> if @isTrees then 1.5 else 1.0
  isWall: () -> 
    (@building instanceof buildings.wall) or @isRocks()

  neighbors: () ->
    ([[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, 1]].map ([q, r]) =>
      game.hexGrid.getHex q+@q, r+@r).filter((elem) -> !!elem)

  distanceTo: ({ q, r }) ->
    (Math.abs(q - @q) + Math.abs(r - @r) + Math.abs(q + r - @q - @r)) / 2
  
  build: (type) ->
    return if @isRocks()
    @building.destroy() if @building
    @building = new buildings[type](@, type)
    @building.addTo @sprite.parent
    @building

  addTo: (container) ->
    container.addChild @sprite
    container.addChild @environmentSprite if @environmentSprite
    # container.addChild @text

window.Hex = Hex


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
