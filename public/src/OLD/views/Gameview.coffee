# class window.Gameview #extends View
#   constructor: () ->
#     window.game = new Crashed()
#     stage.addChild game

#     game.buildPhase()
#     $( "#ui" ).hide()
#     @bindUi()

#   bindUi: () ->
#     $( "#start" ).click () ->
#       game.fightPhase()


#     scale = (d) ->
#       return if game.scale.x + d <=0
#       game.scale.x += d
#       game.scale.y += d

#     $( "#zoomIn" ).click () -> scale 0.25
#     $( "#zoomOut" ).click () -> scale -0.25

#     # $( "#progressbar" ).progressbar { value: 100 }
#     $( "#buildmenu" ).menu().on 'menuselect', (event, ui) ->
#       type = ui.item.text().toLowerCase().split(':')[0]
#       game.build type

#     $( '#buildmenu' ).children().each (i, elem) ->
#       text = $(elem).text()
#       type = text.toLowerCase()
#       $(elem).text(text+': '+game.prices[type].gold+'g')

#     $( '#sellbutton').click () ->
#       numBuildings = (game.selected.filter (h) -> h.building or h.wall).length
#       return alert 'Select buildings to sell.' if numBuildings == 0
#       game.sell()
#       # ...
    
