start = new Date().getTime()
# create an new instance of a pixi stage
stage = new PIXI.Stage(0xFFFFFF);
stage.mousedown = ()->

createHexagon = ({x, y, size, id})->
  hex = new PIXI.Graphics()
    # set a fill and line style
  hex.beginFill 0xFF3300
  hex.lineStyle 2, 0x000000, 1

  # draw a shape
  angle = 0.0
  scale = 1.0
  points = []
  for i in [0...7] by 1
    angle = 1 * Math.PI / 3 * i;
    x_i = Math.round(x + size * Math.cos(angle))
    y_i = Math.round(y + size * Math.sin(angle))
    points.push x_i, y_i
    if i == 0
      hex.moveTo x_i, scale *y_i
    else
      hex.lineTo x_i, scale * y_i
    # hex.moveTo(50,50)
  hex.endFill()
  hex.hitArea = new PIXI.Polygon points
  # hex.setInteractive(true);
  # console.log(stage.interactionManager.interactiveItems)#.push(hex);
  hex.interactive = true
  hex.click = hex.tap = (data) ->
    console.log 'CLICKED', id
  stage.addChild hex

animate = () ->
  thing.clear()
  
  count += 0.01
  
  thing.clear()
  thing.lineStyle 30, 0xff0000, 1
  thing.beginFill 0xffFF00, 0.5
  
  thing.moveTo(-120 + Math.sin(count) * 20, -100 + Math.cos(count)* 20)
  thing.lineTo(120 + Math.cos(count) * 20, -100 + Math.sin(count)* 20)
  thing.lineTo(120 + Math.sin(count) * 20, 100 + Math.cos(count)* 20)
  thing.lineTo(-120 + Math.cos(count)* 20, 100 + Math.sin(count)* 20)
  thing.lineTo(-120 + Math.sin(count) * 20, -100 + Math.cos(count)* 20)
  
  # thing.rotation = count * 0.1;
  renderer.render stage
  requestAnimFrame animate



# stage.mousemove = (data)->
  # console.log(data.originalEvent.x);
  # console.log(stage.getMousePosition());

# stage.setInteractive(true);


#stage.addChild(sprite);
# create a renderer instance
#renderer = new PIXI.CanvasRenderer(800, 600);#PIXI.autoDetectRenderer(800, 600);
renderer = PIXI.autoDetectRenderer 620, 380

# set the canvas width and height to fill the screen
# renderer.view.style.width = window.innerWidth + "px";
# renderer.view.style.height = window.innerHeight + "px";
# renderer.view.style.display = "block";
 
# add render view to DOM
document.body.appendChild renderer.view

size = 40
for col in [0...5] by 1
  for row in [0...10] by 1
    x = (col * size * 3) + (if (row%2) then (size*1.5) else 0)
    y =  row * (Math.sqrt(3)*size)/2
    createHexagon { x, y, size:40, id: row+':'+col}

# lets create moving shape
thing = new PIXI.Graphics()
stage.addChild(thing)
thing.position.x = 620/2
thing.position.y = 380/2

count = 0

# stage.click = stage.tap = (){->
#   graphics.lineStyle(Math.random() * 30, Math.random() * 0xFFFFFF, 1);
#   graphics.moveTo(Math.random() * 620,Math.random() * 380);
#   graphics.lineTo(Math.random() * 620,Math.random() * 380);
# }
console.log('Finished in ', new Date().getTime() - start)
requestAnimFrame animate

