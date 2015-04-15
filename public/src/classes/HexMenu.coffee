class window.HexMenu
  constructor: (game, hex) ->
    @buttons = []

    options = ['sell']
    for upgrade in game.buildingProperties[hex.building.name].upgrades
      options.push upgrade
    
    a = -90
    r = 60
    @sprite = game.worldGroup.create hex.x, hex.y, 'hexMenu'
    @sprite.anchor.set 0.5, 0.5
    @sprite.alpha = .8
    for option in options
      x = Math.cos(a * Math.PI/180) * r
      y = Math.sin(a * Math.PI/180) * r
      a += 40
      button = game.worldGroup.create hex.x+x, hex.y+y, option
      button.anchor.set 0.5, 0.5
      button.height = 30
      button.width = 30
      button.inputEnabled = true
      button.input.useHandCursor = true
      button.events.onInputDown.add ((_type)=> (()=>
        if _type is 'sell'
          game.sell hex
        else
          game.clickUpgradeButton hex, _type
        @remove()
      ))(option)

      @buttons.push button

  remove: () ->
    @sprite.kill()
    button.kill() for button in @buttons