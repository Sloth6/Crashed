class window.Selectable extends PIXI.Sprite
  constructor: ({ x, y, width, height, texture }) ->
    super texture    
    @selected = false
    @anchor = new PIXI.Point .5, .5
    @position.x = x
    @position.y = y
    @width = width
    @height = height
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
