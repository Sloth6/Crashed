class window.Mainmenu extends View
  constructor: () ->
    [ cx, cy ] = [ window.innerWidth // 2, window.innerHeight // 2 ]
    [ w, h ] = [ 326, 287 ]
    
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

    @instructions = new Button {
      texture: textures.mainmenu.instructions
      x: cx
      y: cy - h/2
      hoverTexture: textures.mainmenu.instructionsActive
    }
    super

  bindUi: () ->
    @newGame.mousedown (data) =>
      @newGame.remove()
      @scores.remove()
      @instructions.remove()

      setTimeout (() ->
        game.viewContainer._container.filters = null
        game.start()
      ), 250
    
    @scores.mousedown () =>
      alert 'No scores yet.'

    @instructions.mousedown () =>
      alert 'L2P'