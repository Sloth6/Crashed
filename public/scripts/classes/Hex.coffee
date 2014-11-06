class Hex
  constructor: ({ x, y, size, id, texture, onclick}) ->
    @sprite = new PIXI.Sprite texture
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = x
    @sprite.position.y = y
    @sprite.width = 2*size
    @sprite.height = size * Math.sqrt 3
    @sprite.interactive = true
    
    @Selected = false
    clicked = false

    @sprite.mousedown = (data) ->
      clicked = true
    
    @sprite.mouseup = (data) ->
      @selected = !@selected if clicked
      @alpha = if @selected then .5 else 1.0
    
    @sprite.mousemove = (data) ->
      clicked = false

  addTo : (container) ->
    container.addChild @sprite
    # container.addChild @sprite.hitArea

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
