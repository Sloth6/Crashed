class Crashed.SavedGames
  constructor: (@game) ->

  create: () ->
    window.history.pushState "SavedGames", "", "/saves"
    
    saves = saveManager.loadAll()
    saveGroup = game.add.group()
    y = 0

    height = (saves.length * 100) + 50
    $(game.canvas).css 'height', height
    game.height = height
    game.renderer.resize game.width, height

    monthNames = [
      "January", "February", "March","April", "May", "June", "July",
      "August", "September", "October", "November", "December"]

    if saves.length is 0
      game.add.text game.world.centerX, game.world.centerY, "No saves"
      return

    saves.forEach (save) =>
      return unless save.name
      date = new Date(save.date)
      day = date.getDate()
      month = monthNames[date.getMonth()]

      title = "#{save.name} : #{day} #{month}"
      button = new window.LabelButton @game, game.world.centerX, y+=100, 'foo', title, () =>
        this.state.start 'Game', true, false, save
      saveGroup.add button
        # text = game.add.text game.world.centerX, game.world.centerY, save.name
        # @playButton = @add.button(cx - (3*w/4), cy, 'playButton', @startGame, @, 'buttonOver', 'buttonOut', 'buttonOver');
      
  shutdown: () ->
    console.log 'shitdown'
    game.height = window.innerHeight
    $(game.canvas).css 'height', window.innerHeight
    game.renderer.resize game.width, window.innerHeight

    
  # update: () ->
    # Do some nice funky main menu effect here

  # startGame: (pointer) ->
    # Ok, the Play Button has been clicked or touched, so let's stop the music (otherwise it'll carry on playing)
    # this.music.stop();
    # And start the actual game
    # this.state.start 'Game'