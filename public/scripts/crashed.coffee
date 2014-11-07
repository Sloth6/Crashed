start = new Date().getTime()
stats = {}

renderer = PIXI.autoDetectRenderer window.innerWidth, window.innerHeight
stage = new PIXI.Stage 0xFFFFFF


window.crashed ?= {}
window.crashed.level = 0
window.crashed.gold = 100
# window.buildings ?= {}
window.crashed.prices =
  tower : 10
  collector : 10
  wall : 10
  pylon : 10
window.crashed.buildings = []

animate = () ->
  stats.begin()
  update()
  renderer.render stage
  requestAnimFrame animate
  stats.end()

update = () ->
  window.crashed.buildings.forEach (building) -> building.act()


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
    Wall : PIXI.Texture.fromImage "images/buildings/wall.gif"

  window.grid = new window.HexGrid 6, 40
  window.grid.addTo stage
  console.log('Finished in ', new Date().getTime() - start)
  requestAnimFrame animate

  $( "#progressbar" ).progressbar { value: 37 }
  $( "#buildmenu" ).menu().on 'menuselect', (event, ui) ->
    item = ui.item.text()
    window.selected.forEach (hex) ->
      hex.build item
      hex.selected = false
      hex.hexSprite.alpha = 1.0
    window.selected = []
    # window.selected.forEach (hex) ->
    #   hex.sleecte
    
