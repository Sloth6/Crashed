class HexGrid
  constructor: (rows, size) ->
    @container = new PIXI.DisplayObjectContainer()
    @hexes = {}
    @container.x = window.innerWidth/2
    @container.y = window.innerHeight/2

    # Build map.
    start = 0
    end = rows
    for q in [-rows..rows] by 1
      for r in [start..end] by 1
        x = q * size * 1.5
        y =  ((r * (Math.sqrt(3)*size) + (q * Math.sqrt(3)/2 * size)))/2
        hex = new window.Hex { x, y, size, q, r }
        @hexes[q+':'+r] = hex
        hex.addTo @container
      if q < 0 then start-- else end--

    @container.interactive = true
    @container.buttonMode = true

    @container.mousedown = (data) ->
      @startX = @position.x
      @startY = @position.y
      @startMouseX = data.originalEvent.x
      @startMouseY = data.originalEvent.y
      @dragging = true

    @container.mouseup = @container.mouseupoutside = (data) ->
      @dragging = false

    @container.mousemove = (data) ->
      if @dragging
        mouseDiffX = data.originalEvent.x - @startMouseX
        mouseDiffY = data.originalEvent.y - @startMouseY

        @position.x = @startX + mouseDiffX
        @position.y = @startY + mouseDiffY

  getHex : (q, r) ->
    @hexes[q+':'+r] or null

  getHexFromXY : (x, y) ->
    q = 2 / 3 * x / size
    r = (-1 / 3 * x + 1 / 3 * sqrt(3) * y) / size
    @getHex q, r

  neighbors: ({ q, r }) ->
    [[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, +1]].map(([_q, _r]) =>
      @getHex q+_q, r+_r).filter((elem) -> !!elem)

  selectLine : ({q1, r1}, {q2, r2}) ->
    # TODO
    # N = @getHex({q1, r1}).distanceTo { q2, r2 }
    # for i in [0...N] by 1
    #   THETHING()

  addTo : (scene) ->
    scene.addChild @container  
  
window.HexGrid = HexGrid