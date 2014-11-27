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
    @sprite.height = @hex.sprite.height #/ ratio
    @sprite.width /= ratio #= @hex.sprite.width 
  
  sell: () ->
    @sprite.parent.removeChild @sprite
    @sprite = null
    @hex.building = null
    @hex.wall = null
    game.addGold game.prices[@type]//1.5
  
  destroy: ()  ->
    @onDeath() if @onDeath
    @sprite.parent.removeChild @sprite
    @sprite = null
    @hex.building = null
    @hex.wall = null
  
  addTo: (container) ->
    container.addChild @sprite

window.Building = Building
