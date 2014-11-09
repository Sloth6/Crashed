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
    @sprite.width = 2 * @hex.size
    @sprite.height = @hex.size * Math.sqrt 3
  
  sell: () ->
    # TODO
    # @hex.remove()
    # $$$ += n
  
  addTo: (container) ->
    container.addChild @sprite

window.Building = Building