 class window.Gameview #extends View
  constructor: () ->
    gradient = new PIXI.Sprite PIXI.Texture.fromImage('images/AtmosphericGradient.png')
    gradient.width = window.innerWidth
    gradient.height = window.innerHeight
    stage.addChild gradient

    window.game = new Crashed gameOptions
    game.addTo stage
    game.buildPhase()
    $( "#ui" ).hide()
    @bindUi()
    # game.viewContainer.scale(-0.5)

  bindUi: () ->
    $( "#start" ).click () ->
      game.fightPhase()

    $( "#zoomIn" ).click () ->
      game.viewContainer.scale 0.25
    
    $( "#zoomOut" ).click () ->
      game.viewContainer.scale -0.25

    # $( "#progressbar" ).progressbar { value: 100 }
    $( "#buildmenu" ).menu().on 'menuselect', (event, ui) ->
      type = ui.item.text().toLowerCase().split(':')[0]
      game.build type

    $( '#buildmenu' ).children().each (i, elem) ->
      text = $(elem).text()
      type = text.toLowerCase()
      $(elem).text(text+': '+game.prices[type]+'g')

    $( '#sellbutton').click () ->
      numBuildings = (game.selected.filter (h) -> !!h.building).length
      return alert 'Select buildings to sell.' if numBuildings == 0
      game.sell()
      # ...
    
