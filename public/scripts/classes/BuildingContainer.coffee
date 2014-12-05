class window.BuildingContainer extends PIXI.DisplayObjectContainer
  constructor: (@buildingValidator) ->
    super
    @anchor = new PIXI.Point .5, .5
    @x = window.innerWidth/2
    @y = window.innerHeight/2
  
  get: (type) =>
    if type?
      throw new Error("invalid type: '#{type}'") unless type of buildingClasses
      @children.filter (b) -> b instanceof buildingClasses[type]
    else
      @children

  add: (type, locations) =>
    locations.forEach (hex) =>
      isWall =  type is 'wall'
      b = new buildingClasses[type](hex, type)
      if isWall then hex.addWall b else hex.addBuilding b
      @addChild b

  each: (fun) ->
    return unless @children.length
    @children.forEach fun

  remove: (locations) =>
    locations.forEach (hex) =>
      b = hex.building or hex.wall
      b.sell()
      @removeChild b