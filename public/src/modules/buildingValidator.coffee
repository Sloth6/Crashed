window.buildingValidator =
  canSell: (game) ->
    for hex in selected
      if (hex.q | hex.r) is 0
        return "Cant sell base"
    if not selected.some ((h) -> h.building? or h.wall?)
      return "Select something to sell!"
    true

  canBuild: (game, type) ->
    #check price
    n = game.selectedHexes.length
    cost = n * game.buildingProperties[type].cost
    powerCost = n * game.buildingProperties[type].consumption
    
    if cost > game.money
      return "Cannot afford #{@n} #{type}s. Costs #{cost}."
    
    if powerCost > game.power()
      return "Not enough power. Build more reactors."
    
    if (game.selectedHexes.some (h) -> h.building?)
      return 'Sell that building first!'

    if type is 'wall' #ensure we don't wall off completly.
      aStarOptions =
        graph: game.hexes
        start: hexUtils.ring(game.hexes, game.rows)[0]
        end: game.hexes["0:0"]
        impassable: (h) => h.building is 'wall' or h in game.selectedHexes
        heuristic: hexUtils.hexDistance
        neighbors: hexUtils.neighbors

      if (astar.search aStarOptions).length is 0
        return "Cannot completely wall off base"

    else if type is 'collector'
      if not game.selectedHexes.every((h) -> h.nature is 'minerals')
        return "Can only build collectors on minerals"
    # Treat each building as 'true' which allows us to run a simple
    # algorithm checking if each building is connected without actually
    # creating and destroying each building
    game.selectedHexes.forEach (h) -> h.building = true
    isConnected = @isConnected game
    game.selectedHexes.forEach (h) -> h.building = null
    if not isConnected
      return "Buildings must be adjacent to another building."
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