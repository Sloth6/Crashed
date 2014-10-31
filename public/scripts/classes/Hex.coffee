class Hex
  constructor: ({ x, y, size, id, texture, onclick}) ->
    @sprite = new PIXI.Sprite texture
    @sprite.position.x = x
    @sprite.position.y = y
    @sprite.width = 2*size
    @sprite.height = size * Math.sqrt 3
    @sprite.pivot = new PIXI.Point(size, @sprite.height/2)

    # hex = new PIXI.Graphics()
    #   # set a fill and line style
    # hex.beginFill 0xFF3300
    # hex.lineStyle 2, 0x000000, 1

    angle = 0.0
    scale = 1.0
    points = []
    for i in [0...7] by 1
      angle = 1 * Math.PI / 3 * i;
      x_i = Math.round(x + size * Math.cos(angle))
      y_i = Math.round(y + size * Math.sin(angle))
      points.push x_i, y_i
      # if i == 0
      #   hex.moveTo x_i, scale * y_i
      # else
      #   hex.lineTo x_i, scale * y_i
    # hex.endFill()
    @sprite.hitArea = new PIXI.Polygon points
    @sprite.interactive = true
    # hex.click = hex.tap = (data) ->
    #   onclick data, @
  addTo : (container) ->
    container.addChild @sprite
window.Hex = Hex