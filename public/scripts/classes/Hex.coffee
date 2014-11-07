class Hex
  constructor: ({ @x, @y, @size, @q, @r }) ->
    @selected = false
    @building = 'open'

    @hexSprite = new PIXI.Sprite window.imgAssets.hex
    @hexSprite.anchor.x = 0.5
    @hexSprite.anchor.y = 0.5
    @hexSprite.position.x = @x
    @hexSprite.position.y = @y
    @hexSprite.width = 2*@size
    @hexSprite.height = @size * Math.sqrt 3
    @hexSprite.interactive = true
    
    clicked = false
    @hexSprite.mousedown = (data) =>
      clicked = true
      console.log { q: @q, r: @r }

    @hexSprite.mouseup = (data) =>
      @selected = !@selected if clicked
      @onToggleSelect()
      
    @hexSprite.mousemove = (data) =>
      clicked = false

  getNeighbors : () ->
    [[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, +1]].map ([q, r]) =>
      window.grid.getHex q+@q, r+@r

  distanceTo : ({ q, r }) ->
    (Math.abs(q - @q) + Math.abs(r - @r) + Math.abs(q + r - @q - @r)) / 2
  
  select : () ->
    @selected = !@selected
    @onToggleSelect()

  onToggleSelect : () ->
    if @selected 
      @hexSprite.alpha = .5
      window.selected.push @
    else 
      @hexSprite.alpha = 1.0
      index = window.selected.indexOf @
      window.selected.splice(index, 1);

  build : (type) ->
    @building = new window.buildings[type](@, type)
    @building.addTo @hexSprite.parent

  addTo : (container) ->
    container.addChild @hexSprite

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
