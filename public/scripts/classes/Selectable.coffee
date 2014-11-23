class window.Selectable
  constructor: ({ @x, @y, @width, @height, texture }) ->
    @selected = false

    @sprite = new PIXI.Sprite texture
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @sprite.position.x = @x
    @sprite.position.y = @y
    @sprite.width = @width
    @sprite.height = @height
    @sprite.interactive = true

    clicked = false
    @sprite.mousedown = (data) =>
      clicked = true

    @sprite.mouseup = (data) =>
      @selected = !@selected if clicked
      @onToggleSelect() if clicked and @onToggleSelect
      
    @sprite.mousemove = (data) =>
      clicked = false

  select: () ->
    @selected = !@selected
    @onToggleSelect()
