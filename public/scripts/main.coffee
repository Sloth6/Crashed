$ ->
  start = new Date().getTime()
  
  renderer = PIXI.autoDetectRenderer window.innerWidth, window.innerHeight
  stage = new PIXI.Stage 0xFFFFFF

  document.body.appendChild renderer.view
  renderer.view.style.position = 'absolute'
  renderer.view.style.top = '0px'
  renderer.view.style.left = '0px'

  stats = new Stats()
  document.body.appendChild stats.domElement
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.top = '0px'
  
  window.textures =
    hex: PIXI.Texture.fromImage "images/greenhex.gif"  
    tower: PIXI.Texture.fromImage "images/buildings/tower.gif"
    collector: PIXI.Texture.fromImage "images/buildings/farm2.png"
    pylon: PIXI.Texture.fromImage "images/buildings/pylon.gif"
    wall: PIXI.Texture.fromImage "images/buildings/wall.gif"
    enemy: PIXI.Texture.fromImage 'images/units/enemy.gif'
    barracks: PIXI.Texture.fromImage 'images/buildings/barracks.png'
    # trees: [
    trees0: PIXI.Texture.fromImage 'images/enviornment/trees0.png'
    trees1: PIXI.Texture.fromImage 'images/enviornment/trees1.png'
    trees2: PIXI.Texture.fromImage 'images/enviornment/trees2.png'

    rocks0: PIXI.Texture.fromImage 'images/enviornment/rocks0.png'
    rocks1: PIXI.Texture.fromImage 'images/enviornment/rocks1.png'
    rocks2: PIXI.Texture.fromImage 'images/enviornment/rocks2.png'

  gameOptions =
    levels: 10
    startingGold: 100
    gridSize: 20
    tileSize: 80
    prices: 
      tower: 10
      collector: 10
      wall: 10
      pylon: 10

  window.game = new Crashed gameOptions
  game.addTo stage
  
  gradient = new PIXI.Sprite PIXI.Texture.fromImage('images/AtmosphericGradient.png')
  gradient.width = window.innerWidth
  gradient.height = window.innerHeight
  stage.addChild gradient
  game.run()

  game.hexGrid.getOuterRing()

  $( ".zoomIn").click () ->
    game.viewContainer.scale 0.25
  
  $( ".zoomOut").click () ->
    game.viewContainer.scale -0.25

  $( "#progressbar" ).progressbar { value: 37 }
  $( "#buildmenu" ).menu().on 'menuselect', (event, ui) ->
    type = ui.item.text().toLowerCase()
    game.selected.forEach (hex) ->
      building = hex.build type
      game.buildings.push building
      hex.selected = false
      hex.sprite.alpha = 1.0
    game.selected = []

  animate = () ->
    stats.begin()
    game.update()
    TWEEN.update();
    renderer.render stage
    requestAnimFrame animate
    stats.end()
  
  console.log 'Finished in ', new Date().getTime() - start
  requestAnimFrame animate

Math.randInt = (min, max) ->
    if !max
      max = min
      min = 0
    Math.floor(Math.random() * (max - min)) + min

window.random = (array) ->
  array[Math.randInt(array.length)]