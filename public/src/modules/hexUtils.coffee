# In the axial cooridnate system (http://www.redblobgames.com/grids/hexagons/)
# These are the relative direction to go from any hex
directions = [[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, 1]]

hexUtils =
  XYtoHex: (x, y) ->
    q = Math.floor((x * Math.sqrt(3) / 3 - y / 3) / 40)
    r = Math.floor(y * 2 / 3 / 40)
    { q, r }

  neighbors: ( hexes, {q,r} ) ->
    mapped = (hexes["#{dq+q}:#{dr+r}"] for [dq, dr] in directions)
    (item for item in mapped when !!item)

  hexDistance: (a, b) ->
    (Math.abs(a.q - b.q) + Math.abs(a.r - b.r) + Math.abs(a.q + a.r - b.q - b.r)) / 2

  ring: (hexes, r, c) ->
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
  
  nearestHex: (hexes, x, y) ->
    min = Infinity
    minHex = null
    for k, hex of hexes
      distance = ((hex.x - x)**2 + (hex.y - y)**2)**.5
      if distance < min
        min = distance
        minHex = hex
    minHex

  getDistricts: (hexes) ->
    filter = (h) -> h._district is null and h.type != 'road'
    floodFill = (hex, districtName) ->
      fill = [] # collect all hexes in the same district as 'hex'
      floodFillR = (h) -> #recursive sub function of flood fill
        h.setText districtName
        h._district = districtName
        neighbors = hexUtils.neighbors(hexes, h).filter filter
        fill.concat neighbors
        floodFillR _h for _h in neighbors
      floodFillR hex
      fill

    open = [] #copy the array
    for _, h of hexes
      h._district = null
      h.setText ''
      open.push h

    i = 0
    while open.length > 0 #while some hexes are not assigned to districts
      floodFill open.pop(), "D:#{i++}"
      open = open.filter filter
    null
    # districts = []
