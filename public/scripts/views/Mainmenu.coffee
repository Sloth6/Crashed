class window.Mainmenu extends View
  constructor: () ->
    [ cx, cy ] = [ window.innerWidth // 2, window.innerHeight // 2 ]
    w = 326
    h = 287

    @newGame = new Button {
      texture: textures.mainmenu.newGame
      x: cx - (3*w/4)
      y: cy
      hoverTexture: textures.mainmenu.newGameActive
    }

    @scores = new Button {
      texture: textures.mainmenu.scores
      x: cx
      y: cy + h/2
      hoverTexture: textures.mainmenu.scoresActive
    }

    @credits = new Button {
      texture: textures.mainmenu.credits
      x: cx
      y: cy - h/2
      hoverTexture: textures.mainmenu.creditsActive
    }


    # window.stage.addChild @newGame
    # window.stage.addChild @scores
    # window.stage.addChild @credits

    super

  bindUi: () ->
    # @newGame.mouseover = () ->
    #   @setTexture textures.mainmenu.newGameActive
    # @newGame.mouseout = () ->
    #   @setTexture textures.mainmenu.newGame

    @newGame.mousedown (data) =>
      @newGame.remove()
      @scores.remove()
      @credits.remove()
      game.start()
    
    @scores.mousedown () =>
      alert 'No scores yet.'

    @credits.mousedown () =>
      alert 'Sloth Norder 2v2 bronze team.'