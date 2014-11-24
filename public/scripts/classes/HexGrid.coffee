class window.HexGrid
  constructor: (@rows, size, hexGeneratingFun) ->
    @container = new PIXI.DisplayObjectContainer()
    @hexes = {}
    @directions = [[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, +1]]
    @container.x = window.innerWidth/2
    @container.y = window.innerHeight/2

    width = 2 * size
    height = size * Math.sqrt(3) * 0.5 #.5 is for isometric effect
    # Build map.
    start = 0
    end = @rows
    for q in [-@rows..@rows] by 1
      for r in [start..end] by 1
        { building, type, gold } = hexGeneratingFun q, r
        options = { width, height, q, r, gold }
        switch type
          when 'rocks' then hex = new window.Rocks options
          when 'trees' then hex = new window.Trees options
          else hex = new window.Hex options
          
        @hexes[q+':'+r] = hex
        hex.addTo @container
        hex.build(building) if building
      # this creates the hex shape with axial coordinates
      if q < 0 then start-- else end--

  getHex: (q, r) ->
    @hexes[q+':'+r] or null

  #not sure if this actually works
  getHexFromXY: (x, y) ->
    q = 2 / 3 * x / size
    r = (-1 / 3 * x + 1 / 3 * sqrt(3) * y) / size
    @getHex q, r

  neighbors: ({ q, r }) -> @getHex(q, r).neighbors()
  distance: ({ q, r }, b) -> @getHex(q, r).distanceTo b

  # using a* since we want the path to go around existing objects
  getLine: ({ q1, r1 }, { q2, r2 }) ->
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
