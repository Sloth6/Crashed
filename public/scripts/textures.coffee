console.time "loadTextures"
fromImage = PIXI.Texture.fromImage

window.textures =
  base: fromImage "images/buildings/base.png"
  hex: fromImage "images/greenhex.gif"
  tower: fromImage "images/buildings/tower.gif"
  farm: fromImage "images/buildings/farm2.png"
  collector: fromImage "images/buildings/collector.png"
  road: fromImage "images/buildings/pylon.gif"
  barracks: fromImage 'images/buildings/barracks.png'
  wall: fromImage "images/buildings/wall.png"
  smallBlob: fromImage 'images/units/enemy.gif'
  largeBlob: fromImage 'images/units/bigEnemy.gif'
  resourcesFull: fromImage 'images/enviornment/resourcesFull.gif'
  resourcesHalf: fromImage 'images/enviornment/resourcesHalf.gif'      
  
  trees0: fromImage 'images/enviornment/trees0.png'
  trees1: fromImage 'images/enviornment/trees1.png'
  trees2: fromImage 'images/enviornment/trees2.png'
  rocks0: fromImage 'images/enviornment/rocks0.png'
  rocks1: fromImage 'images/enviornment/rocks1.png'
  rocks2: fromImage 'images/enviornment/rocks2.png'
  
  walls:
    topLeft: fromImage 'images/buildings/wall/top-left.png'
    topRight: fromImage 'images/buildings/wall/top-right.png'
    bottomLeft: fromImage 'images/buildings/wall/bottom-left.png'
    bottomRight: fromImage 'images/buildings/wall/bottom-right.png'
    top: fromImage 'images/buildings/wall/top.png'
    bottom: fromImage 'images/buildings/wall/bottom.png'

  mainmenu:
    gradient: fromImage 'images/mainmenu/gradient.png' 
    newGame: fromImage 'images/mainmenu/New.gif'
    scores: fromImage 'images/mainmenu/Scores.gif'
    credits: fromImage 'images/mainmenu/Credits.gif'
    newGameActive: fromImage 'images/mainmenu/NewActive.gif'
    scoresActive: fromImage 'images/mainmenu/ScoresActive.gif'
    creditsActive: fromImage 'images/mainmenu/CreditsActive.gif'
    instructions: fromImage 'images/mainmenu/Instructions.gif'
    instructionsActive: fromImage 'images/mainmenu/InstructionsActive.gif'

console.timeEnd "loadTextures"