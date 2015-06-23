

window.buildingValidator =
  canBuildRoad = (game) ->
    true
  canBuild: (game, building) ->
    n = game.selectedHexes.length
    cost = n * building.cost

    if cost > game.money
      "Cannot afford #{@n} #{type}s. Costs #{cost}."
    
    else if building is Road #ensure we don't wall off completly.
      canBuildWall(game) 

    else
      true
