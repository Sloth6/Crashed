class window.HexMenu
  constructor: (@game, hex, @parent) ->
    @buttons = []

    options = [['sell', ((game, hex) -> game.sell hex), -1 * @parent.constructor.cost]]
    for upgrade in @parent.constructor.upgrades
      options.push upgrade
    
    a = -90
    r = 120
    @sprite = @game.worldGroup.create hex.x, hex.y, 'hexMenu'
    @sprite.anchor.set 0.5, 0.5
    @sprite.scale.set 2.0, 2.0

    @text = @game.add.text hex.x, hex.y - 1.5*r , "hello"

    console.log(options)
    for [name, func, cost] in options 
      x = Math.cos(a * Math.PI/180) * r
      y = Math.sin(a * Math.PI/180) * r
      a += 40
      button = @game.worldGroup.create hex.x+x, hex.y+y, name
      button.anchor.set 0.5, 0.5
      button.height = 60
      button.width = 60
      button.inputEnabled = true
      button.input.useHandCursor = true
      button.events.onInputDown.add () =>
        @clickButton hex, name, func, cost
        @remove()

      button.events.onInputOver.add () =>
        @overButton hex, name, cost

      @buttons.push button

  remove: () ->
    @sprite.destroy()
    @text.destroy()
    button.destroy() for button in @buttons

  clickButton: (hex, name, func, cost) ->
    if cost > @game.money
      alert "Cannot afford #{name}, costs $#{cost}"
      return false
    game.money -= cost if name isnt 'sell'
    func(@game, hex)
    @game.rangeDisplay.update()
    @game.updateStatsText()
    @game.clearSelected()
    # if option is 'sell' then @game.sell hex
    # else if @parent instanceof Base
    #   @game.money -= cost
    #   upgrade(@game)
    # else 
    #   @game.build hex, upgrade
    #   @game.money -= cost
    #   @game.rangeDisplay.update()
    #   @game.updateStatsText()
    #   @game.clearSelected()
  overButton: (hex, name, cost) ->
    if name is 'sell' then message = 'Sell for $#{cost}'
    else if @parent instanceof Base then message = "base upgrade for $#{cost}"
    else message = '#{name}: $#{cost}'
    @text.setText message
