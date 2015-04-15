window.pathfinding =
  run: (game) ->
    # Store an array of the 'frontier.'
    open = []
    # Initialize all hexes based off their building type
    for _, hex of game.hexes
      hex.closestNeighbor = null
      if hex.building instanceof Buildings.Collector or hex.building instanceof Buildings.Base
        hex._d = 0
        # Add all neighbors to the frontier
        open = open.concat hexUtils.neighbors(game.hexes, hex)
      else if hex.building instanceof Buildings.Wall
        hex._d = Infinity
      else
        hex._d = null
  
    # While there are hexes that have not been examined    
    while open.length > 0
      newOpen = []
      for hex in open
        continue unless hex._d is null
        neighbors = hexUtils.neighbors game.hexes, hex

        # Deside the distance to the closest collector or base.
        # This is 1+ min of neighbors.
        min = Infinity
        closestNeighbor = null
        for _hex in neighbors.filter((h) -> h._d != null)
          if _hex._d < min
            min = _hex._d
            closestNeighbor = _hex
        hex._d = min + 1
        hex.closestNeighbor = closestNeighbor
        # game.add.text hex.x, hex.y, ""+hex._d

        # Move the frontier one step out. Dont add hexes that have already
        # been examined.
        newOpen = newOpen.concat(neighbors.filter((hex) -> hex? and hex._d is null))
      open = newOpen
    null