start = new Date().getTime()
stage = new PIXI.Stage(0xFFFFFF);

stage.mousedown = () ->

texture = PIXI.Texture.fromImage "images/hex.png"
createHexagon = ({ x, y, size, id }) ->
  
  hex = new PIXI.Sprite texture
  hex.position.x = x
  hex.position.y = y
  hex.width = 2*size
  hex.height = (Math.sqrt(3)*size)

  # hex = new PIXI.Graphics()
  #   # set a fill and line style
  # hex.beginFill 0xFF3300
  # hex.lineStyle 2, 0x000000, 1

  angle = 0.0
  scale = 1.0
  points = []
  for i in [0...7] by 1
    angle = 1 * Math.PI / 3 * i;
    x_i = Math.round(x + size * Math.cos(angle))
    y_i = Math.round(y + size * Math.sin(angle))
    points.push x_i, y_i
    # if i == 0
    #   hex.moveTo x_i, scale * y_i
    # else
    #   hex.lineTo x_i, scale * y_i
  # hex.endFill()
  hex.hitArea = new PIXI.Polygon points
  hex.interactive = true
  hex.click = hex.tap = (data) ->
    console.log 'CLICKED', id
  # stage.addChild hex
  stage.addChild hex

animate = () ->
  # thing.rotation = count * 0.1;
  renderer.render stage
  requestAnimFrame animate



# stage.mousemove = (data)->
  # console.log(data.originalEvent.x);
  # console.log(stage.getMousePosition());

# stage.setInteractive(true);


#stage.addChild(sprite);
# create a renderer instance


makeWorld = () ->
  size = 40
  for col in [0...5] by 1
    for row in [0...10] by 1
      x = (col * size * 3) + (if (row%2) then (size*1.5) else 0)
      y =  row * (Math.sqrt(3)*size)/2
      createHexagon { x, y, size:40, id: row+':'+col}



# main = () ->
renderer = PIXI.autoDetectRenderer 620, 380
document.body.appendChild renderer.view
makeWorld()
console.log('Finished in ', new Date().getTime() - start)
requestAnimFrame animate


# main()
# stage.click = stage.tap = (){->
#   graphics.lineStyle(Math.random() * 30, Math.random() * 0xFFFFFF, 1);
#   graphics.moveTo(Math.random() * 620,Math.random() * 380);
#   graphics.lineTo(Math.random() * 620,Math.random() * 380);
# }

