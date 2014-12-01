class Building
  constructor: ( @hex, @type, scaleTofit = true ) ->
    if window.game
      cost = game.prices[@type]
      return if cost > game.gold
      game.addGold(-cost)

    @foodCost = 0
    @destroyed = false
    @sprite = new PIXI.Sprite window.textures[@type]
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = @hex.x
    @sprite.position.y = @hex.y

    if scaleTofit
      ratio = @sprite.height / @hex.height
      @sprite.height = @hex.height #/ ratio
      @sprite.width /= ratio #= @hex.width 
  
  sell: () ->
    @sprite.parent.removeChild @sprite
    @sprite = null
    @hex.building = null
    game.addGold game.prices[@type]//1.5
  

  act: () ->

  destroy: ()  ->
    @onDeath() if @onDeath
    @sprite.parent.removeChild @sprite
    @sprite = null
    @hex.building = null
    @hex.wall = null
    @destroyed = true
  
  addTo: (container) ->
    container.addChild @sprite

window.Building = Building
