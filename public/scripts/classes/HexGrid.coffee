class HexGrid
  constructor: (@rows, size, hexGeneratingFun) ->
    @container = new PIXI.DisplayObjectContainer()
    @hexes = {}
    @directions = [[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, +1]]
    @container.x = window.innerWidth/2
    @container.y = window.innerHeight/2

    width = 2 * size
    height = size * Math.sqrt(3) * 0.5
    # Build map.
    start = 0
    end = @rows
    for q in [-@rows..@rows] by 1
      for r in [start..end] by 1
        { building, environment, gold } = hexGeneratingFun q, r
        hexOptions = { width, height, q, r, environment, gold }
        hex = new window.Hex hexOptions
        @hexes[q+':'+r] = hex
        hex.addTo @container
        hex.build(building) if building
      # this creates the hex shape with axial coordinates
      if q < 0 then start-- else end--

  getHex: (q, r) ->
    @hexes[q+':'+r] or null

  getHexFromXY: (x, y) ->
    q = 2 / 3 * x / size
    r = (-1 / 3 * x + 1 / 3 * sqrt(3) * y) / size
    @getHex q, r

  neighbors: ({ q, r }) ->
    @directions.map(([_q, _r]) =>
      @getHex q+_q, r+_r).filter((elem) -> !!elem)

  getLine: ({q1, r1}, {q2, r2}) ->
    # TODO
    # N = @getHex({q1, r1}).distanceTo { q2, r2 }
    # for i in [0...N] by 1
    #   THETHING()

  getRing: (r) ->
    hex = @getHex -r, r
    ringHexes = []
    for i in [0...6] by 1
      direction = @directions[i]
      for j in [0...r] by 1
        ringHexes.push hex
        hex = @getHex hex.q+direction[0], hex.r+direction[1]
    
    ringHexes
  
  getOuterRing: () ->
    @getRing @rows

  addTo : (scene) ->
    scene.addChild @container
  
window.HexGrid = HexGrid
