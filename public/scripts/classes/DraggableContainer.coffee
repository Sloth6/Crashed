class DraggableContainer
  constructor: () ->
    @_container = new PIXI.DisplayObjectContainer()
    @_container.interactive = true
    @_container.buttonMode = true
    @position = @_container.position

    @_container.mousedown = (data) ->
      @_startX = @position.x
      @_startY = @position.y
      @_startMouseX = data.originalEvent.x
      @_startMouseY = data.originalEvent.y
      @_dragging = true

    @_container.mouseup = @_container.mouseupoutside = (data) ->
      @_dragging = false

    @_container.mousemove = (data) ->
      if @_dragging
        mouseDiffX = data.originalEvent.x - @_startMouseX
        mouseDiffY = data.originalEvent.y - @_startMouseY

        @position.x = @_startX + mouseDiffX
        @position.y = @_startY + mouseDiffY

  scale : (d) ->
    return if @_container.scale.x + d <= 0
    @_container.scale.x += d
    @_container.scale.y += d

  addTo : (scene) ->
    scene.addChild @_container

  addChild : (child) ->
    @_container.addChild child

window.DraggableContainer = DraggableContainer
