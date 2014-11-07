class Building
  constructor: ( @hex, @type ) ->
    cost = window.crashed.prices[@type]
    return if @cost > window.crashed.gold
    window.crashed.gold -= @cost

    @sprite = new PIXI.Sprite window.imgAssets[@type]
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = @hex.x
    @sprite.position.y = @hex.y
    @sprite.width = 2*@hex.size
    @sprite.height = @hex.size * Math.sqrt 3
    # @sprite.interactive = true
    window.crashed.buildings.push(@)
  sell: () ->
    # @hex.remove()
    # TODO
  addTo : (container) ->
    container.addChild @sprite

window.Building = Building