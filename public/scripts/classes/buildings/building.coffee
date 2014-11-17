class Building
  constructor: ( @hex, @type ) ->
    cost = game.prices[@type]
    return if @cost > game.gold
    game.gold -= @cost

    @sprite = new PIXI.Sprite textures[@type]
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = @hex.x
    @sprite.position.y = @hex.y
    ratio = @sprite.height / @hex.sprite.height
    @sprite.width /= ratio#= @hex.sprite.width
    @sprite.height /= ratio#= @hex.sprite.height
  
  sell: () ->
  # TODO
  # @hex.remove()
  # $$$ += n
  
  destroy: ()  ->
    @sprite.parent.removeChild @sprite
    @sprite = null
    @hex.building = null
  
  addTo: (container) ->
    container.addChild @sprite

window.Building = Building