console.time 'totalLoading'
console.time 'parsingHtml'
$ ->
  console.timeEnd 'parsingHtml'
  console.time 'creatingRenderer'
  PIXI.dontSayHello = true #sorry pixi
  renderer = PIXI.autoDetectRenderer window.innerWidth, window.innerHeight

  $( window ).resize () -> 
    renderer.resize window.innerWidth, window.innerHeight

  window.stage = new PIXI.Stage 0xFFFFFF

  document.body.appendChild renderer.view
  renderer.view.style.position = 'absolute'
  renderer.view.style.top = '0px'
  renderer.view.style.left = '0px'

  stats = new Stats()
  document.body.appendChild stats.domElement
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.top = '0px'
  console.timeEnd 'creatingRenderer'

  window.gameOptions =
    levels: 10
    startingGold: 100
    gridSize: 14
    tileSize: 80
    gold: 100
    prices:
      base: 0
      tower: 10
      road: 4
      collector: 10
      farm: 10
      wall: 2
      pylon: 10

  
  new Gameview()
  new Mainmenu()

  blurFilter = new PIXI.BlurFilter()
  blurFilter.blur = 7
  game.viewContainer.filters = [blurFilter]
  
  animate = () ->
    stats.begin()
    game.update() if game?
    TWEEN.update()
    renderer.render window.stage
    requestAnimFrame animate
    stats.end()
  
  requestAnimFrame animate
  console.timeEnd 'totalLoading'

#extend default object (a bad practice SHHHHH)
Math.randInt = (min, max) ->
    if !max
      max = min
      min = 0
    Math.floor(Math.random() * (max - min)) + min

window.random = (array) ->
  return null if array.length is 0
  array[Math.randInt(array.length)]
