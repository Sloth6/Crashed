start = new Date().getTime()
hexContainer = {}
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
  grid  = new window.HexGrid 4, PIXI.Texture.fromImage "images/hex.png"  
  grid.addTo stage
  console.log('Finished in ', new Date().getTime() - start)
  requestAnimFrame animate
