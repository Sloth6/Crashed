console.time 'totalLoading'
console.time 'parsingHtml'
$ ->
  console.timeEnd 'parsingHtml'

  console.time 'creatingRenderer'
  PIXI.dontSayHello = true #sorry pixi
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
  console.timeEnd 'creatingRenderer'

  gameOptions =
    levels: 10
    startingGold: 100
    gridSize: 14
    tileSize: 80
    gold: 100
    prices:
      tower: 10
      road: 4
      collector: 10
      farm: 10
      wall: 2
      pylon: 10

  window.game = new Crashed gameOptions

  game.addTo stage
  bindUi game
  
  gradient = new PIXI.Sprite PIXI.Texture.fromImage('images/AtmosphericGradient.png')
  gradient.width = window.innerWidth
  gradient.height = window.innerHeight
  stage.addChild gradient
  game.buildPhase()

  animate = () ->
    stats.begin()
    game.update()
    TWEEN.update()
    renderer.render stage
    requestAnimFrame animate
    stats.end()
  
  requestAnimFrame animate
  console.timeEnd 'totalLoading'

bindUi = (game) ->
  $( "#start" ).click () ->
    game.fightPhase()

  $( "#zoomIn" ).click () ->
    game.viewContainer.scale 0.25
  
  $( "#zoomOut" ).click () ->
    game.viewContainer.scale -0.25

  # $( "#progressbar" ).progressbar { value: 100 }
  $( "#buildmenu" ).menu().on 'menuselect', (event, ui) ->
    type = ui.item.text().toLowerCase().split(':')[0]
    game.build type

  $( '#buildmenu' ).children().each (i, elem) ->
    text = $(elem).text()
    type = text.toLowerCase()
    $(elem).text(text+': '+game.prices[type]+'g')

  $( '#sellbutton').click () ->
    numBuildings = (game.selected.filter (h) -> !!h.building or !!h.wall).length
    return alert 'Select buildings to sell.' if numBuildings == 0
    game.sell()

# =======
#     type = ui.item.text().toLowerCase()
#     if game.selected.length == 2 and type == "wall"
#       path = game.hexGrid.getLine(game.selected[0], game.selected[1])
#       path.push(game.selected[0])
#       path.forEach (hex) ->
#         building = hex.build "wall"
#         game.buildings.push building if building
#         hex.selected = false
#         hex.sprite.alpha = 1.0
      
#     else
#       game.selected.forEach (hex) ->
#         building = hex.build type
#         game.buildings.push building if building
#         hex.selected = false
#         hex.sprite.alpha = 1.0
#     game.selected = []
# >>>>>>> 939daccf9d345733876dd32f156f8e341732f4dc

#extend default object (a bad practice SHHHHH)
Math.randInt = (min, max) ->
    if !max
      max = min
      min = 0
    Math.floor(Math.random() * (max - min)) + min

window.random = (array) ->
  array[Math.randInt(array.length)]
