window.pathfinding =
  pointNeighborsToward: (startingHex) ->
    for hex in startingHex.neighbors
      if hex.
        hex.closestNeighbor ?= startingHex
        pointNeighborsToward hex
  run: (game) ->
    game.pathfinding_running = true
    # Store an array of the 'frontier.'
    frontier = []
    # Initialize all hexes based off their building type
    for _, hex of game.hexes
      hex.closestNeighbor = null
    for hex in game.hexes
      if hex.building instanceof Base
        pointNeighborsToward hex
        break
      hex._d = null
      if (hex.building and hex.building.alive) and hex.building instanceof Base
        hex._d = 0
        hex.closestNeighbor = hex
        # Add all neighbors to the frontier
        frontier = frontier.concat hexUtils.neighbors(game.hexes, hex)

    # While there are hexes that have not been examined    
    while frontier.length > 0
      newOpen = []
      for hex in frontier 
        continue unless hex._d is null
        neighbors = hexUtils.neighbors game.hexes, hex

        # Decide the distance to the closest collector or base.
        # This is 1+ min of neighbors.
        min = Infinity
        closestNeighbor = null
        for _hex in neighbors.filter((h) -> h._d != null)
          if _hex._d < min
            g = 0
            if hex.nature is 'trees' 
              g = 2
            else if hex.building instanceof Wall
              g = 5
              
            
            min = _hex._d + g + 1
            closestNeighbor = _hex
        hex._d = min# + (if hex.nature is 'trees' then 2 else 1)
        hex.closestNeighbor = closestNeighbor
        # Move the frontier one step out. Dont add hexes that have already
        # been examined.
        newOpen = newOpen.concat(neighbors.filter((hex) -> hex? and hex._d is null))
      frontier = newOpen

    for _, hex of game.hexes
      # hex.setText ''+hex._d
      if hex._d is null
        return false
      
    game.pathfinding_running = false
    true
    # null