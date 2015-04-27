$ ->
  # console.log $('#gameContainer').css('height')
  window.game = new Phaser.Game window.innerWidth, window.innerHeight, Phaser.AUTO, $('#gameContainer')[0]
  # console.log $('#gameContainer').css('height')
  #Add the States your game has.
  game.state.add 'Boot', Crashed.Boot
  game.state.add 'Preloader', Crashed.Preloader
  game.state.add 'MainMenu', Crashed.MainMenu
  game.state.add 'SavedGames', Crashed.SavedGames
  game.state.add 'Game', Crashed.Game


  #Now start the Boot state.
  game.state.start 'Boot'