class window.Selectable extends PIXI.DisplayObjectContainer
  constructor: ({ x, y, width, height, texture }) ->
    super

    @anchor = new PIXI.Point .5, .5
    @position.x = x
    @position.y = y

    sprite = new PIXI.Sprite texture
    sprite.anchor = new PIXI.Point .5, .5
    sprite.width = width
    sprite.height = height
    
    @addChild sprite
    @selected = false

    @interactive = true
    @clicked = false

  mousedown: (data) =>
    @clicked = true

  mouseup: (data) =>
    @selected = !@selected if @clicked
    @onToggleSelect() if @clicked and @onToggleSelect
      
  mousemove: (data) =>
    @clicked = false

  select: () ->
    @selected = !@selected
    @onToggleSelect()
