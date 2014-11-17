class HexGrid
  constructor: (@rows, size) ->
    @container = new PIXI.DisplayObjectContainer()
    @hexes = {}
    @directions = [[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, +1]]
    @container.x = window.innerWidth/2
    @container.y = window.innerHeight/2

    width = 2 * size
    height = size * Math.sqrt(3) * .5
    # Build map.
    start = 0
    end = @rows
    for q in [-@rows..@rows] by 1
      for r in [start..end] by 1
        x = q * size * 1.5
        y =  ((r * (Math.sqrt(3)*size) + (q * Math.sqrt(3)/2 * size))) * .5
        hex = new window.Hex { x, y, width, height, q, r }
        @hexes[q+':'+r] = hex
        hex.addTo @container
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