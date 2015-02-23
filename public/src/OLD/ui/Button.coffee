class window.Button extends PIXI.Sprite
  constructor: ({ x, y, texture, hoverTexture }) ->
    super texture
    @_texture = texture
    @_hoverTexture = hoverTexture
    @anchor = { x: 0.5, y: 0.5 }
    @position = { x, y }
    @interactive = true
    @buttonMode = true
    stage.addChild @

  mouseover: () =>
    @setTexture @_hoverTexture
    
  mouseout: () =>
    @setTexture @_texture

  mousedown: (data) =>
    @downfun data if @downfun
    
  onClick: (@downfun) =>
  
  remove: () =>
    @parent.removeChild @