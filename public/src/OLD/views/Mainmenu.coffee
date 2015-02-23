class window.Mainmenu extends View
  constructor: () ->
    [ cx, cy ] = [ window.innerWidth / 2, window.innerHeight / 2 ]
    [ w, h ] = [ 326, 287 ]
    
    @newGame = new HexButton {
      x: cx - (3*w/4), y: cy, r: w/2
      texture: textures.mainmenu.newGame
      hoverTexture: textures.mainmenu.newGameActive
    }

    @scores = new HexButton {
      x: cx, y: cy + h/2, r: w/2
      texture: textures.mainmenu.scores
      hoverTexture: textures.mainmenu.scoresActive
    }

    @instructions = new HexButton {
      x: cx, y: cy - h/2, r: w/2
      texture: textures.mainmenu.instructions
      hoverTexture: textures.mainmenu.instructionsActive
    }

    super

  move: () ->
    [ cx, cy ] = [ window.innerWidth / 2, window.innerHeight / 2 ]
    [ w, h ] = [ 326, 287 ]
    @newGame.x = cx - (3*w/4)
    @newGame.y = cy
    @scores.x = cx
    @scores.y = cy + h/2
    @instructions.x = cx
    @instructions.y = cy - h/2

  bindUi: () ->
    @newGame.onClick (data) =>
      @newGame.remove()
      @scores.remove()
      @instructions.remove()

      setTimeout (() ->
        game.filters = null
        game.start()
      ), 250
    
    @scores.onClick () ->
      alert 'No scores yet.'

    @instructions.onClick () ->
      alert 'L2P'