class window.GameUI
  constructor: () ->
    @updateInfo()
    $( "#start" ).click () ->
      numEnemies = game.enemiesPerLevel().total
      $('#buildmenu,#sellbutton').hide()
      $('#start').hide()
      $('.progress-label').text numEnemies
      $('#progressbar').progressbar({ value: 100 }).show()
      game.emit 'fightPhase'

    scale = (d) ->
      return if game.hexGrid.scale.x + d <=0
      game.hexGrid.scale.x += d
      game.hexGrid.scale.y += d

    $( "#zoomIn" ).click () -> scale 0.25
    $( "#zoomOut" ).click () -> scale -0.25

    # $( "#progressbar" ).progressbar { value: 100 }
    $( "#buildmenu" ).menu().on 'menuselect', (event, ui) ->
      type = ui.item.text().toLowerCase().split(':')[0]
      game.emit 'build', [type]
      # game.build type

    $( '#buildmenu' ).children().each (i, elem) ->
      text = $(elem).text()
      type = text.toLowerCase()
      $(elem).text(text+': '+game.prices[type].gold+'g')

    $( '#sellbutton').click () -> game.emit 'sell'

    game.addListener 'buildPhase', () ->
      $('#leveltext').text('Level: '+game.level)
      $('#start').show()
      $('#buildmenu,#sellbutton').show()
      $('#progressbar').hide()

    game.addListener 'enemyDeath', (enemy) ->
      numEnemies = game.enemiesPerLevel().total
      value = game.enemies.count() * 100 / numEnemies
      $('#progressbar').progressbar { value }
      $( ".progress-label" ).text game.enemies.count()

    game.addListener 'resourceChange', @updateInfo

  updateInfo: () ->
    $('#goldtext').text 'Gold: '+game.gold
    $('#foodtext').text 'Food: '+game.getFood()
    $('#leveltext').text 'Level: '+game.level