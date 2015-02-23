$ ->
  window.game = new Phaser.Game 1024, 768, Phaser.AUTO, 'gameContainer'
  # view.physics.startSystem Phaser.Physics.ARCADE

  #Add the States your game has.
  game.state.add('Boot', Crashed.Boot)
  game.state.add('Preloader', Crashed.Preloader)
  game.state.add('MainMenu', Crashed.MainMenu)
  game.state.add('Game', Crashed.Game)

  #Now start the Boot state.
  game.state.start('Boot');