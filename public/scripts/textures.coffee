console.time "loadTextures"
window.textures =
  base: PIXI.Texture.fromImage "images/buildings/base.png"
  hex: PIXI.Texture.fromImage "images/greenhex.gif"
  tower: PIXI.Texture.fromImage "images/buildings/tower.gif"
  farm: PIXI.Texture.fromImage "images/buildings/farm2.png"
  collector: PIXI.Texture.fromImage "images/buildings/collector.png"
  road: PIXI.Texture.fromImage "images/buildings/pylon.gif"
  barracks: PIXI.Texture.fromImage 'images/buildings/barracks.png'
  wall: PIXI.Texture.fromImage "images/buildings/wall.png"
  smallBlob: PIXI.Texture.fromImage 'images/units/enemy.gif'
  largeBlob: PIXI.Texture.fromImage 'images/units/bigEnemy.gif'
  resourcesFull: 'images/enviornment/resourcesFull.png'
  resourcesHalf: 'images/enviornment/resourcesHalf.png'      
  trees0: PIXI.Texture.fromImage 'images/enviornment/trees0.png'
  trees1: PIXI.Texture.fromImage 'images/enviornment/trees1.png'
  trees2: PIXI.Texture.fromImage 'images/enviornment/trees2.png'
  rocks0: PIXI.Texture.fromImage 'images/enviornment/rocks0.png'
  rocks1: PIXI.Texture.fromImage 'images/enviornment/rocks1.png'
  rocks2: PIXI.Texture.fromImage 'images/enviornment/rocks2.png'
console.timeEnd "loadTextures"