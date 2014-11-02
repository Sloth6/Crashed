class Hex
  constructor: ({ x, y, size, @id, texture, onclick}) ->
    @sprite = new PIXI.Sprite texture
    @sprite.position.x = x
    @sprite.position.y = y
    @sprite.width = 2*size
    @sprite.height = size * Math.sqrt 3
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5

    hex = new PIXI.Graphics()
    hex.beginFill 0xFF3300
    hex.lineStyle 2, 0x000000, 1

    angle = 0.0
    scale = 1.0
    points = []
    for i in [0...7] by 1
      angle = 1 * Math.PI / 3 * i;
      x_i = Math.round(x + size * Math.cos(angle))
      y_i = Math.round(y + size * Math.sin(angle))
      points.push x_i, y_i
      if i == 0
        hex.moveTo x_i, scale * y_i
      else
        hex.lineTo x_i, scale * y_i

    hex.endFill()
    # hex.drawPolygon points

    @sprite.hitArea = new PIXI.Polygon points
    @sprite.interactive = true
    @sprite.mouseover = (data) ->
      console.log @id
      # @rotation = 3.14159
      @alpha = 0.5
    
    @sprite.mouseout = (data) ->
      @alpha = 1.0

    # hex.click = hex.tap = (data) ->
    #   onclick data, @
    @hex = hex
  addTo : (container) ->
    container.addChild @sprite
    # container.addChild @sprite.hitArea

window.Hex = Hex