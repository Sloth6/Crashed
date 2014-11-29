class window.Button
  constructor: ({ x, y, @texture, @hoverTexture }) ->
    @sprite = new PIXI.Sprite @texture
    @sprite.anchor = { x: 0.5, y: 0.5 }
    @sprite.position = { x, y }
    @sprite.interactive = true
    @sprite.buttonMode = true
    
    @sprite.mouseover = () =>
      @sprite.setTexture @hoverTexture
    
    @sprite.mouseout = () =>
      @sprite.setTexture @texture

    @sprite.mousedown = (data) =>
      @downfun data if @downfun
    window.stage.addChild @sprite

  mousedown: (@downfun) =>
  
  remove: () =>
    new TWEEN.Tween @sprite
      .to { alpha: 0 }, 300
      .easing TWEEN.Easing.Linear.None
      .onComplete () => window.stage.removeChild @sprite
      .start()
