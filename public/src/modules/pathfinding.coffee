window.pathfinding =
  run: (game) ->
    pointNeighborsToward = (game, startingHex) ->
      neighborRoads = []
      for hex in hexUtils.neighbors game.hexes, startingHex
        if hex.type is 'road' and hex.closestNeighbor is null
          neighborRoads.push hex
          hex.closestNeighbor = startingHex
      for neighborRoad in neighborRoads
        pointNeighborsToward game, neighborRoad

    # Initialize all hexes based off their building type
    for _, hex of game.hexes
      hex.closestNeighbor = null

    for _, hex of game.hexes
      if hex.type is 'base'
        pointNeighborsToward game, hex
        hex.closestNeighbor = hex
        break
    true
    # null