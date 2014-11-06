class HexGrid
  constructor: (rows, texture) ->
    @container = new PIXI.DisplayObjectContainer()
    size = 40
    @container.x = window.innerWidth/2
    @container.y = window.innerHeight/2

    # Build map.
    start = 0
    end = rows
    for col in [-rows..rows] by 1
      for row in [start..end] by 1
        x = col * size * 1.5
        y =  row * (Math.sqrt(3)*size) + (col * Math.sqrt(3)/2 * size)
        hex = new window.Hex { x, y, size, id: col+':'+row, texture }
        hex.addTo @container
      if col < 0 then start-- else end--

    @container.interactive = true
    @container.buttonMode = true

    @container.mousedown = (data) ->
      @startX = @position.x
      @startY = @position.y
      @startMouseX = data.originalEvent.x
      @startMouseY = data.originalEvent.y
      @dragging = true

    @container.mouseup = @container.mouseupoutside = (data) ->
      @dragging = false

    @container.mousemove = @container.touchmove = (data) ->
      if @dragging
        mouseDiffX = data.originalEvent.x - @startMouseX
        mouseDiffY = data.originalEvent.y - @startMouseY

        @position.x = @startX + mouseDiffX
        @position.y = @startY + mouseDiffY
 
  addTo : (scene) ->
    scene.addChild @container  
  
window.HexGrid = HexGrid