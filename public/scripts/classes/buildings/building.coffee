class Building
  constructor: ( @hex, @type ) ->
    if window.game
      cost = game.prices[@type]
      return if cost > game.gold
      game.gold -= cost
      $('#goldtext').text('Gold: '+game.gold)

    @sprite = new PIXI.Sprite window.textures[@type]
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = @hex.x
    @sprite.position.y = @hex.y
    ratio = @sprite.height / @hex.sprite.height
    @sprite.width = @hex.sprite.width
    @sprite.height = @hex.sprite.height
  
  sell: () ->
  # TODO
  # @hex.remove()
  # $$$ += n
  
  destroy: ()  ->
    @onDeath() if @onDeath
    @sprite.parent.removeChild @sprite
    @sprite = null
    @hex.building = null
  
  addTo: (container) ->
    container.addChild @sprite

window.Building = Building