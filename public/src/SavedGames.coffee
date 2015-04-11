class Crashed.SavedGames
  constructor: (game) ->

  create: () ->
    # @add.sprite 0, 0, 'titlepage'
    saves = localStorage.getItem "crashedSavedGames"
    if saves and saves.length > 0
      saves.forEach (save) ->
        save = JSON.parse save
        text = game.add.text game.world.centerX, game.world.centerY, save.date, style
    else
      game.add.text game.world.centerX, game.world.centerY, "No saves"

    
  update: () ->
    # Do some nice funky main menu effect here

  startGame: (pointer) ->
    # Ok, the Play Button has been clicked or touched, so let's stop the music (otherwise it'll carry on playing)
    # this.music.stop();
    # And start the actual game
    this.state.start 'Game'