class Hex
  constructor: ({ x, y, size, @q, @r, texture }) ->
    @sprite = new PIXI.Sprite texture
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = x
    @sprite.position.y = y
    @sprite.width = 2*size
    @sprite.height = size * Math.sqrt 3
    @sprite.interactive = true
    
    @selected = false
    clicked = false

    @sprite.mousedown = (data) =>
      clicked = true
      console.log {q:@q, r:@r}

    @sprite.mouseup = (data) ->
      @selected = !@selected if clicked
      @alpha = if @selected then .5 else 1.0
      
    @sprite.mousemove = (data) ->
      clicked = false

  getNeighbors : () ->
    [[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, +1]].map ([q, r]) =>
      window.grid.getHex q+@q, r+@r

  select : () ->
    @selected = !@selected
    @sprite.alpha = if @selected then .5 else 1.0

  addTo : (container) ->
    container.addChild @sprite

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
