# In the axial cooridnate system (http://www.redblobgames.com/grids/hexagons/)
# These are the relative direction to go from any hex
directions = [[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, 1]]

hexUtils =
  directions: directions

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
    
    # Filter hexes that cant be in district
    filter = (h) -> h._district is null and h.type not in ['road', 'base']

    # Given a hex, get its cluster
    getDistrictFor = (hex, districtName) ->
      roads = [] # Collect all roads that border district
      interior = [hex] # Collect all hexes in district
      is_exterior = false
      floodFillR = (h) -> # Recursive sub function that adds to district
        h._district = districtName
        neighbors = hexUtils.neighbors(hexes, h)
        if neighbors.length != 6
          is_exterior = true
        toCheck = neighbors.filter filter
        interior = interior.concat toCheck
        roads = roads.concat neighbors.filter (h) -> h.type is 'road'
        for _h in toCheck
          floodFillR _h
      floodFillR hex
      
      if is_exterior
        null
      else
        new District(roads, interior, districtName)

    districts = []
    open = [] #copy the array
    for _, h of hexes
      h._district = null
      open.push h if h.type not in ['road', 'base']
      
    i = 0
    while open.length > 0 #while some hexes are not assigned to districts
      district = getDistrictFor(open.pop(), "D:#{i++}")
      districts.push district if district?
      open = open.filter filter
    
    for _,h of hexes
      h._district = null

    console.log districts
    districts
