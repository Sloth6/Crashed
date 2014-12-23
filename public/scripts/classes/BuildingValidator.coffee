class window.BuildingValidator
  constructor: ( ) ->
  
  canSell: (selected) ->
    err = ''
    for hex in selected
      if (hex.q | hex.r) is 0
        err = "You really don't want to sell that..."
        break
    if not selected.some ((h) -> h.building? or h.wall?)
      err = "Select something to sell!"
    
    if err 
      alert err
      false
    else 
      true

  canBuild: (type, game) ->
    #check price
    selected = game.selected
    n = selected.length
    cost = n * game.prices[type].gold
    foodCost = n * game.prices[type].food
    err = null

    if cost > game.gold
      err = "Cannot afford #{@n} #{type}s. Costs #{totalCost}g."
    
    if foodCost > game.getFood()
      err = "Not enough food. Build more farms."
    
    if selected.some((h) -> h.building? or h.wall?)
      err = 'Sell that building first!'

    if type is 'wall' #ensure we don't wall off completly.
      start = game.hexGrid.getOuterRing()[0]
      end = game.hexGrid.getHex 0, 0
      options = {impassable: (h) -> h.isWall() or h.isRocks() or h in selected }
      if astar.search(game.hexGrid, start, end, options).length == 0
        err = "Cannot completely wall off base"
    else # only applies to non-walls
      # Treat each building as 'true' which allows us to run a simple
      # algorithm checking if each building is connected without actually
      # creating and destroying each building
      selected.forEach (h) -> h.building = true
      isConnected = @isConnected(type, game)
      selected.forEach (h) -> h.building = null
      if not isConnected
        err = "Buildings (not walls) must be adjacent to another building."
    if err 
      alert err
      false
    else 
      true

  isConnected: (type, game) ->
    numSeen = 0
    seen = {}
    # recursively check all neighbors
    checkR = (h) ->
      return if not h.hasBuilding()
      return if seen[h.q+':'+h.r]?
      #record all the buildings we reach from the center.
      seen[h.q+':'+h.r] = true
      numSeen++
      h.neighbors().forEach checkR

    checkR game.hexGrid.getHex(0,0)
    # ensure we see every buildings thbat will be built.
    numBuildings = game.buildings.get().length-game.buildings.get('wall').length
    numSeen == numBuildings + game.selected.length