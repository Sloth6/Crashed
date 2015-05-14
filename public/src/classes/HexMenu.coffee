class window.HexMenu
  constructor: (game, hex, parent) ->
    @buttons = []

    options = ['sell']
    for upgrade in game.buildingProperties[hex.building.name].upgrades
      options.push upgrade
    
    a = -90
    r = 120
    @sprite = game.worldGroup.create hex.x, hex.y, 'hexMenu'
    @sprite.anchor.set 0.5, 0.5
    @sprite.scale.set 2.0, 2.0

    @text = game.add.text hex.x, hex.y - 1.5*r , "hello"

    options.forEach (option) =>
      x = Math.cos(a * Math.PI/180) * r
      y = Math.sin(a * Math.PI/180) * r
      a += 40
      button = game.worldGroup.create hex.x+x, hex.y+y, option
      button.anchor.set 0.5, 0.5
      button.height = 60
      button.width = 60
      button.inputEnabled = true
      button.input.useHandCursor = true
      button.events.onInputDown.add () =>
        console.log("option is #{option}");
        if option is 'sell'
          game.sell hex
        else
          game.clickUpgradeButton hex, option
        @remove()

      button.events.onInputOver.add () =>
        if option is 'sell'
          s = "Sell for $#{game.buildingProperties[parent.name].cost}"
        else
          s = "#{option} upgrade: #{game.buildingProperties[option].cost}"
        @text.setText s

      @buttons.push button

  remove: () ->
    @sprite.destroy()
    @text.destroy()
    button.destroy() for button in @buttons