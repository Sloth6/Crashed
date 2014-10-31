start = new Date().getTime()
hexContainer = {}
stats = {}

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

animate = () ->
  stats.begin()
  update()
  renderer.render stage
  requestAnimFrame animate
  stats.end()

update = () ->
  # if mousedown
  #   hexContainer.position.x = mapStart.x + mouseCurrent.x - mouseStart.x
  #   hexContainer.position.y = mapStart.y + mouseCurrent.y - mouseStart.y


# main = () ->

$ ->
  document.body.appendChild renderer.view
  renderer.view.style.position = "absolute";
  stats = new Stats();
  document.body.appendChild( stats.domElement );
  stats.domElement.style.position = "absolute";
  stats.domElement.style.top = "0px";
  # makeWorld()
  grid  = new window.HexGrid 10, 4, PIXI.Texture.fromImage "images/hex.png"  
  grid.addTo stage
  console.log('Finished in ', new Date().getTime() - start)
  requestAnimFrame animate


# main()
# stage.click = stage.tap = (){->
#   graphics.lineStyle(Math.random() * 30, Math.random() * 0xFFFFFF, 1);
#   graphics.moveTo(Math.random() * 620,Math.random() * 380);
#   graphics.lineTo(Math.random() * 620,Math.random() * 380);
# }

