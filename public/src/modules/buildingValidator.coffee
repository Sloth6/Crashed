window.buildingValidator =
  canSell: (game) ->
    for hex in selected
      if (hex.q | hex.r) is 0
        return "Cant sell base"
    if not selected.some ((h) -> h.building? or h.wall?)
      return "Select something to sell!"
    true

  canBuild: (game, type) ->
    n = game.selectedHexes.length
    cost = n * game.buildingProperties[type].cost

    if cost > game.money
      return "Cannot afford #{@n} #{type}s. Costs #{cost}."
    
    if (game.selectedHexes.some (h) -> h.building?)
      return 'Sell that building first!'

    if type != 'Wall' and game.selectedHexes.some((h) -> !h.powered)
      return "Buildings must be built on powered tiles"

    if type is 'Wall' #ensure we don't wall off completly.
      aStarOptions =
        graph: game.hexes
        start: hexUtils.ring(game.hexes, game.rows)[0]
        end: game.hexes["0:0"]
        impassable: (h) -> h.building instanceof Buildings.Wall or h in game.selectedHexes
        heuristic: hexUtils.hexDistance
        neighbors: hexUtils.neighbors

      if (astar.search aStarOptions).length is 0
        return "Cannot completely wall off base"

    else if type is 'collector'
      if not game.selectedHexes.every((h) -> h.nature is 'minerals')
        return "Can only build collectors on minerals"
  
    true

  isConnected: (game) ->
    numSeen = 0
    seen = {}
    # recursively check all neighbors
    checkR = (h) ->
      return if not h.building?
      return if seen[h.q+':'+h.r]?
      #record all the buildings we reach from the center.
      seen[h.q+':'+h.r] = true
      numSeen++

      hexUtils.neighbors(game.hexes, h).forEach checkR

    checkR game.hexes["0:0"]
    # ensure we see every buildings thbat will be built.
    numSeen == game.buildings.length + game.selectedHexes.length