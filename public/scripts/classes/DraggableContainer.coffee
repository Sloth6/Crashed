class window.DraggableContainer extends PIXI.DisplayObjectContainer
  constructor: () ->
    # @pivot = 
    super
    @interactive = false
    @buttonMode = true
    

  mousedown: (data) =>
    @startX = @position.x
    @startY = @position.y
    @startMouseX = data.originalEvent.x
    @startMouseY = data.originalEvent.y
    @dragging = true

  mouseup: () => @dragging = false

  mousemove: (data) =>
    if @dragging
      mouseDiffX = data.originalEvent.x - @startMouseX
      mouseDiffY = data.originalEvent.y - @startMouseY
      @position.x = @startX + mouseDiffX
      @position.y = @startY + mouseDiffY

  changeScale : (d) ->
    return if @scale.x + d <= 0
    @scale.x += d
    @scale.y += d
    # @container.x -= 775*d
    # @container.y -= 300*d

  setDraggable: (bool) ->
    @interactive = bool
