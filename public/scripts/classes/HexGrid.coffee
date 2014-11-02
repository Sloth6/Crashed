class HexGrid
  constructor: (rows, cols, texture) ->
    # @container = new PIXI.DisplayObjectContainer()
    size = 40
    @container = new PIXI.SpriteBatch()
    @container.x = 0
    @container.y = 0
    @container.width = 3*size*cols
    @container.height = Math.sqrt(3)*size*rows
    
    # Build map.
   
    for col in [0...cols] by 1
      for row in [0...rows] by 1
        x = (col * size * 3) + (if (row%2) then (size*1.5) else 0)
        y =  row * (Math.sqrt(3)*size)/2
        hex = new window.Hex({ x, y, size:40, id: row+':'+col, texture })
        hex.addTo @container

    @container.interactive = true
    @container.buttonMode = true

    @container.mousedown = (data) ->
      # console.log 'mosueDown', @downdata.originalEvent
      # data.originalEvent.preventDefault()
      
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