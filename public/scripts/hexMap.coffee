start = new Date().getTime()
hexContainer = {}


renderer = PIXI.autoDetectRenderer 620, 380
stage = new PIXI.Stage 0xFFFFFF
mousedown = false

mouseStart = {}
mouseCurrent = {}
mapStart = {}

stage.mousedown = (data) ->
  mapStart.x = hexContainer.x
  mapStart.y = hexContainer.y
  mouseStart.x = data.originalEvent.x
  mouseStart.y = data.originalEvent.y
  mousedown = true

stage.mouseup = () ->
  mousedown = false

stage.mousemove = (data) ->
  mouseCurrent.x = data.originalEvent.x
  mouseCurrent.y = data.originalEvent.y

createHexagon = ({ x, y, size, id }) ->
  texture = PIXI.Texture.fromImage "images/hex.png"  
  hex = new PIXI.Sprite texture
  hex.position.x = x
  hex.position.y = y
  hex.width = 2*size
  hex.height = (Math.sqrt(3)*size)
  new PIXI.Point(size, hex.height/2)

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
  hex

animate = () ->
  stats.begin()
  update()
  renderer.render stage
  requestAnimFrame animate
  stats.end()

update = () ->
  if mousedown
    hexContainer.position.x = mapStart.x + mouseCurrent.x - mouseStart.x
    hexContainer.position.y = mapStart.y + mouseCurrent.y - mouseStart.y


makeWorld = () ->
  hexContainer = new PIXI.DisplayObjectContainer()
  hexContainer = new PIXI.SpriteBatch()
  hexContainer.x = 0
  hexContainer.y = 0
  stage.addChild hexContainer
  size = 40
  for col in [0...5] by 1
    for row in [0...10] by 1
      x = (col * size * 3) + (if (row%2) then (size*1.5) else 0)
      y =  row * (Math.sqrt(3)*size)/2
      hexContainer.addChild createHexagon { x, y, size:40, id: row+':'+col }
  return



# main = () ->


document.body.appendChild renderer.view
renderer.view.style.position = "absolute";
stats = new Stats();
document.body.appendChild( stats.domElement );
stats.domElement.style.position = "absolute";
stats.domElement.style.top = "0px";
makeWorld()

console.log('Finished in ', new Date().getTime() - start)
requestAnimFrame animate


# main()
# stage.click = stage.tap = (){->
#   graphics.lineStyle(Math.random() * 30, Math.random() * 0xFFFFFF, 1);
#   graphics.moveTo(Math.random() * 620,Math.random() * 380);
#   graphics.lineTo(Math.random() * 620,Math.random() * 380);
# }

