start = new Date().getTime()
stats = {}

renderer = PIXI.autoDetectRenderer window.innerWidth, window.innerHeight
stage = new PIXI.Stage 0xFFFFFF

animate = () ->
  stats.begin()
  update()
  renderer.render stage
  requestAnimFrame animate
  stats.end()

update = () ->


$ ->
  document.body.appendChild renderer.view
  renderer.view.style.position = "absolute";
  renderer.view.style.top = "0px";
  renderer.view.style.left = "0px";

  stats = new Stats();
  document.body.appendChild( stats.domElement );
  stats.domElement.style.position = 'absolute';
  stats.domElement.style.top = "0px";
  # makeWorld()
  
  window.selected = []

  window.imgAssets = 
    hex : PIXI.Texture.fromImage "images/hex.png"  
    Tower : PIXI.Texture.fromImage "images/buildings/tower.gif"
    Collector : PIXI.Texture.fromImage "images/buildings/collector.png"
    Pylon : PIXI.Texture.fromImage "images/buildings/pylon.gif"
    Wall : PIXI.Texture.fromImage "images/buildings/Wall.gif"

  window.grid = new window.HexGrid 3
  window.grid.addTo stage
  console.log('Finished in ', new Date().getTime() - start)
  requestAnimFrame animate

  $( "#progressbar" ).progressbar { value: 37 }
  $( "#buildmenu" ).menu().on 'menuselect', (event, ui) ->
    item = ui.item.text()
    console.log window.selected
    window.selected.forEach (hex) ->
      # hex.select()
      hex.build item
    window.selected.forEach (hex) ->
      hex.select()
    
