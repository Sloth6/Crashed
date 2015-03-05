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
      return "Cannot afford #{@n} #{type}s. Costs #{totalCost}g."
    
    if powerCost > game.power()
      return "Not enough power. Build more reactors."
    
    if (game.selectedHexes.some (h) -> h.building?)
      return 'Sell that building first!'
    true
    # if type is 'wall' #ensure we don't wall off completly.
    #   start = game.hexGrid.getOuterRing()[0]
    #   end = game.hexGrid.getHex 0, 0
    #   options = {impassable: (h) -> h.isWall() or h.isRocks() or h in selected }
    #   if astar.search(game.hexGrid, start, end, options).length == 0
    #     err = "Cannot completely wall off base"
    # else # only applies to non-walls
    #   # Treat each building as 'true' which allows us to run a simple
    #   # algorithm checking if each building is connected without actually
    #   # creating and destroying each building
    #   selected.forEach (h) -> h.building = true
    #   isConnected = @isConnected(type, game)
    #   selected.forEach (h) -> h.building = null
    #   if not isConnected
    #     err = "Buildings (not walls) must be adjacent to another building."
    # if err 
    #   alert err
    #   false
    # else 
    # true

  # isConnected: (game, type) ->
  #   numSeen = 0
  #   seen = {}
  #   # recursively check all neighbors
  #   checkR = (h) ->
  #     return if not h.hasBuilding()
  #     return if seen[h.q+':'+h.r]?
  #     #record all the buildings we reach from the center.
  #     seen[h.q+':'+h.r] = true
  #     numSeen++
  #     h.neighbors().forEach checkR

  #   checkR game.hexGrid.getHex(0,0)
  #   # ensure we see every buildings thbat will be built.
  #   numBuildings = game.buildings.get().length-game.buildings.get('wall').length
  #   numSeen == numBuildings + game.selected.length