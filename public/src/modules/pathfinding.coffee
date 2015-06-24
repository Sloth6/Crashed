window.pathfinding =
  run: (game) ->
    pointNeighborsToward = (game, startingHex) ->
      for hex in hexUtils.neighbors game.hexes, startingHex
        if hex.type is 'road' and hex.closestNeighbor is null
          hex.closestNeighbor = startingHex
          pointNeighborsToward game, hex

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