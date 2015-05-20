window.buildingValidator =
  canSell: (game) ->
    for hex in selected
      if (hex.q | hex.r) is 0
        return "Cant sell base"
    if not selected.some ((h) -> h.building? or h.wall?)
      return "Select something to sell!"
    true

  canBuild: (game, building) ->
    n = game.selectedHexes.length
    cost = n * building.cost

    if cost > game.money
      return "Cannot afford #{@n} #{type}s. Costs #{cost}."
    
    if (game.selectedHexes.some (h) -> h.building?)
      return 'Sell that building first!'

    if building isnt Wall and game.selectedHexes.some((h) -> !h.powered)
      return "Buildings must be built on powered tiles"

    if building is Wall #ensure we don't wall off completly.
      for hex in game.selectedHexes
        hex.building = 'planned_wall'

      for hex in game.selectedHexes
        hex.building = null
      
    else if building is Collector
      if not game.selectedHexes.every((h) -> h.nature is 'minerals')
        return "Can only build collectors on minerals"
  
    true

  # isConnected: (game) ->
  #   numSeen = 0
  #   seen = {}
  #   # recursively check all neighbors
  #   checkR = (h) ->
  #     return if not h.building?
  #     return if seen[h.q+':'+h.r]?
  #     #record all the buildings we reach from the center.
  #     seen[h.q+':'+h.r] = true
  #     numSeen++

  #     hexUtils.neighbors(game.hexes, h).forEach checkR

  #   checkR game.hexes["0:0"]
  #   # ensure we see every buildings thbat will be built.
  #   numSeen == game.buildings.length + game.selectedHexes.length