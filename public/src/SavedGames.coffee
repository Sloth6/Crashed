class Crashed.SavedGames
  constructor: (@game) ->

  create: () ->
    # @add.sprite 0, 0, 'titlepage'
    saves = saveManager.loadAll()
    # console.log saves
    y = 0
    if saves.length > 0
      saves.forEach (save) =>
        # save = JSON.parse save
        return unless save.name
        new window.LabelButton @game, 100, y+=100, 'start', save.name, () =>
          this.state.start 'Game', true, false, save
        # text = game.add.text game.world.centerX, game.world.centerY, save.name
        # @playButton = @add.button(cx - (3*w/4), cy, 'playButton', @startGame, @, 'buttonOver', 'buttonOut', 'buttonOver');
    else
      game.add.text game.world.centerX, game.world.centerY, "No saves"

    
  # update: () ->
    # Do some nice funky main menu effect here

  # startGame: (pointer) ->
    # Ok, the Play Button has been clicked or touched, so let's stop the music (otherwise it'll carry on playing)
    # this.music.stop();
    # And start the actual game
    # this.state.start 'Game'