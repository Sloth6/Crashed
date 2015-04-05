class window.Building extends PIXI.DisplayObjectContainer
  constructor: ( @hex, @type, scaleTofit = true ) ->
    super
    @position = @hex.position
    @cost = 0
    @foodCost = 0
    @destroyed = false
    
    sprite = new PIXI.Sprite window.textures[@type]
    sprite.anchor = new PIXI.Point .5, .5

    if scaleTofit
      ratio = sprite.height / @hex.height
      sprite.height = @hex.height #/ ratio
      sprite.width /= ratio #= @hex.width

    @addChild sprite
  
  sell: () ->
    @hex.building = null
    @hex.wall = null

  act: () ->

  destroy: ()  ->
    @onDeath() if @onDeath
    @hex.building = null
    @hex.wall = null
    @destroyed = true