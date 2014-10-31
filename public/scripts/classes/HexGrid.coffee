class HexGrid
  constructor: (rows, cols, texture) ->
    # @container = new PIXI.DisplayObjectContainer()
    @container = new PIXI.SpriteBatch()
    @container.x = 0
    @container.y = 0
    size = 40
    for col in [0...cols] by 1
      for row in [0...rows] by 1
        x = (col * size * 3) + (if (row%2) then (size*1.5) else 0)
        y =  row * (Math.sqrt(3)*size)/2
        hex = new window.Hex({ x, y, size:40, id: row+':'+col, texture })
        hex.addTo @container
 
  addTo : (scene) ->
    scene.addChild @container  
  
window.HexGrid = HexGrid