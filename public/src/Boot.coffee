Crashed = {}
Buildings = {}

class Crashed.Boot
  init: () ->
    #  Unless you specifically know your game needs to support multi-touch I
    #  would recommend setting this to 1
    @input.maxPointers = 1

    #  Phaser will automatically pause if the browser tab the game is in
    # loses focus. You can disable that here:
    @stage.disableVisibilityChange = true

    if @game.device.desktop
      game.scale.scaleMode = Phaser.ScaleManager.RESIZE;
      #  If you have any desktop specific settings, they can go in here
      # @scale.setMinMax 480, 260, 1024, 768
      # #scaling options
      # this.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL;
      @scale.pageAlignHorizontally = true #have the game centered
      @scale.pageAlignVertically = true
      @scale.setScreenSize(true) # #screen size will be set automatically


    else
      #  Same goes for mobile settings.
      #  In this case we're saying "scale the game, no lower than 480x260 and
      # no higher than 1024x768"
      @scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
      @scale.setMinMax 480, 260, 1024, 768
      @scale.forceLandscape = true
      @scale.pageAlignHorizontally = true

    Array.prototype.remove = (e) ->
      i = @indexOf e
      @splice(i, 1) if i > -1
      @

    Array.prototype.random = () ->
      @[Math.floor(Math.random()*@length)]

    game.canvas.oncontextmenu = (e) -> e.preventDefault()

    $(window).resize () ->
      height = window.innerHeight
      width = window.innerWidth
      # console.log game, game.stage
      game.width = width
      game.height = height
      game.stage.width = width
      game.stage.height = height

      if (game.renderType == 1)
        game.renderer.resize(width, height)
        # Phaser.Canvas.setSmoothingEnabled(game.context, false)
        game.scale.setGameSize(width, height);

  preload: () ->
    #  Here we load the assets required for our preloader (in this case a
    #  background and a loading bar)
    @load.image('background', 'images/mainmenu/background.png')
    @load.image('loadingBar', 'images/loading.png')

  create: () ->
    #  By this point the preloader assets have loaded to the cache, we've set
    #  the game settings So now let's start the real preloader going.
    state = @state
    # game = @game
    window.onpopstate = (e) ->
      if e.state
        state.start e.state



    state.start 'Preloader'
