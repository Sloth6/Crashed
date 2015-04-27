class Crashed.SavedGames
  constructor: (@game) ->

  create: () ->
    window.history.pushState "SavedGames", "", "/saves"
    # @add.sprite 0, 0, 'titlepage'
    saves = saveManager.loadAll()

    y = 0
    monthNames = [
        "January", "February", "March",
        "April", "May", "June", "July",
        "August", "September", "October",
        "November", "December"
    ]

    if saves.length > 0
      saves.forEach (save) =>
        # save = JSON.parse save
        return unless save.name
        date = new Date(save.date)
        day = date.getDate()
        month = monthNames[date.getMonth()]

        title = "#{save.name} : #{day} #{month}"
        new window.LabelButton @game, game.world.centerX, y+=100, 'foo', title, () =>
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