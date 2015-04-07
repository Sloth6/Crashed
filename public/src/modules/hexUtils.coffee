# In the axial cooridnate system (http://www.redblobgames.com/grids/hexagons/)
# These are the relative direction to go from any hex
directions = [[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, 1]]

hexUtils =
  XYtoHex: (x, y) ->
    q = Math.floor((x * Math.sqrt(3) / 3 - y / 3) / 40)
    r = Math.floor(y * 2 / 3 / 40)
    { q, r }

  neighbors: ( hexes, {q,r} ) ->
    (directions.map ([ dq, dr ]) => hexes["#{dq+q}:#{dr + r}"])
      .filter (elem) -> !!elem


  hexDistance: (a, b) ->
    (Math.abs(a.q - b.q) + Math.abs(a.r - b.r) + Math.abs(a.q + a.r - b.q - b.r)) / 2

  ring: (hexes, r, c) ->
    # console.log hexes, r, c
    c ?= { q: 0, r: 0 }
    hex = hexes["#{-r+c.q}:#{r+c.r}"]
    ringHexes = []
    for i in [0...6] by 1
      for _ in [0...r] by 1
        ringHexes.push hex
        q = hex.q+directions[i][0]
        _r = hex.r+directions[i][1]
        hex = hexes["#{q}:#{_r}"]
    ringHexes
  nearestHex: (game, x, y) ->
    min = Infinity
    minHex = null
    for k, hex of game.hexes
      distance = ((hex.x - x)**2 + (hex.y - y)**2)**.5
      if distance < min
        min = distance
        minHex = hex
    minHex


# console.log hexUtils.XYtoHex({x: 2, y:3})