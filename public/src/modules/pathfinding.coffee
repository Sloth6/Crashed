window.pathfinding =
  pointNeighborsToward: (game, startingHex) ->
    for hex in hexUtils.neighbors game.hexes, startingHex
      if hex.type is 'road'
        hex.closestNeighbor ?= startingHex
        pointNeighborsToward game, hex
  run: (game) ->
    game.pathfinding_running = true
    # Initialize all hexes based off their building type
    for _, hex of game.hexes
      hex.closestNeighbor = null
    for hex in game.hexes
      if hex.type is 'base'
        pointNeighborsToward game, hex
        hex.closestNeighbor = hex
        break
    game.pathfinding_running = false
    true
    # null