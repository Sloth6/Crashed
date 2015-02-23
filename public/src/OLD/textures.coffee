console.time "loadTextures"
fromImage = PIXI.Texture.fromImage

window.preload () ->
  game.load.image 'base', "images/buildings/base.png"
  game.load.image 'hex', "images/greenhex.gif"
  game.load.image 'tower', "images/buildings/tower.gif"
  game.load.image 'farm', "images/buildings/farm2.png"
  game.load.image 'collector', "images/buildings/collector.png"
  game.load.image 'road', "images/buildings/pylon.gif"
  game.load.image 'barracks', 'images/buildings/barracks.png'
  game.load.image 'wall', "images/buildings/wall.png"
  game.load.image 'smallBlob', 'images/units/enemy.gif'
  game.load.image 'largeBlob', 'images/units/bigEnemy.gif'
  game.load.image 'resourcesFull', 'images/enviornment/resourcesFull.gif'
  game.load.image 'resourcesHalf', 'images/enviornment/resourcesHalf.gif'
  
  game.load.image 'trees0', 'images/enviornment/trees0.png'
  game.load.image 'trees1', 'images/enviornment/trees1.png'
  game.load.image 'trees2', 'images/enviornment/trees2.png'
  game.load.image 'rocks0', 'images/enviornment/rocks0.png'
  game.load.image 'rocks1', 'images/enviornment/rocks1.png'
  game.load.image 'rocks2', 'images/enviornment/rocks2.png'
  
  game.load.image 'wall_topLeft', 'images/buildings/wall/top-left.png'
  game.load.image 'wall_topRight', 'images/buildings/wall/top-right.png'
  game.load.image 'wall_bottomLeft', 'images/buildings/wall/bottom-left.png'
  game.load.image 'wall_bottomRight', 'images/buildings/wall/bottom-right.png'
  game.load.image 'wall_top', 'images/buildings/wall/top.png'
  game.load.image 'wall_bottom', 'images/buildings/wall/bottom.png'

  game.load.image 'gradient', 'images/mainmenu/gradient.png'
  game.load.image 'newGame', 'images/mainmenu/New.gif'
  game.load.image 'scores', 'images/mainmenu/Scores.gif'
  game.load.image 'credits', 'images/mainmenu/Credits.gif'
  game.load.image 'newGameActive', 'images/mainmenu/NewActive.gif'
  game.load.image 'scoresActive', 'images/mainmenu/ScoresActive.gif'
  game.load.image 'creditsActive', 'images/mainmenu/CreditsActive.gif'
  game.load.image 'instructions', 'images/mainmenu/Instructions.gif'
  game.load.image 'instructionsActive', 'images/mainmenu/InstructionsActive.gif'

console.timeEnd "loadTextures"