class window.BuildingContainer extends view.add.group
  constructor: () ->
    super
    @anchor = new PIXI.Point .5, .5
  
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
    @updateTextures()
    null

  each: (fun) ->
    return unless @children.length
    @children.forEach fun
    null

  remove: (locations) =>
    locations.forEach (hex) =>
      b = hex.building or hex.wall
      b.sell()
      @removeChild b
    @updateTextures()
    null

  updateTextures: () ->
    b.updateTexture() for b in @get 'wall'
    null