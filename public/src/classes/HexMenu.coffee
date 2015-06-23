# class window.HexMenu
#   constructor: (@game, hex, @parent) ->
#     @buttons = []

#     options = [{name: 'sell', func: ((game, hex) -> game.sell hex), cost: -1 * @parent.constructor.cost}]
#     for upgrade in @parent.constructor.upgrades
#       options.push upgrade
    
#     a = -90
#     r = 120
#     @sprite = @game.worldGroup.create hex.x, hex.y, 'hexMenu'
#     @sprite.anchor.set 0.5, 0.5
#     @sprite.scale.set 2.0, 2.0

#     @text = @game.add.text hex.x, hex.y - 1.5*r , "hello"

#     console.log(options)
#     for option in options 
#       x = Math.cos(a * Math.PI/180) * r
#       y = Math.sin(a * Math.PI/180) * r
#       a += 40
#       button = @game.worldGroup.create hex.x+x, hex.y+y, option.name
#       button.anchor.set 0.5, 0.5
#       button.height = 60
#       button.width = 60
#       button.inputEnabled = true
#       button.input.useHandCursor = true
#       button.alpha = if option.purchased then .5 else 1
#       unless option.purchased
#         button.events.onInputDown.add (@clickButton hex, option)

#       button.events.onInputOver.add (@overButton hex, option)

#       @buttons.push button

#   remove: () ->
#     @sprite.destroy()
#     @text.destroy()
#     button.destroy() for button in @buttons

#   clickButton: (hex, option) =>
#     () =>
#       if option.cost > @game.money
#         alert "Cannot afford #{option.name}, costs $#{option.cost}"
#         return false
#       @game.money -= option.cost if option.name isnt 'sell'
#       option.func(@game, hex)
#       @game.rangeDisplay.update()
#       @game.updateStatsText()
#       @game.clearSelected()
#       if @parent instanceof Base then option.purchased = true
#       @remove()

#   overButton: (hex, option) =>
#     () =>
#       if option.purchased then message = "This has already been purchased"
#       else if option.name is 'sell' then message = "Sell for $#{-1 * option.cost}"
#       else if @parent instanceof Base then message = "base upgrade for $#{option.cost}"
#       else message = "#{option.name}: $#{option.cost}"
#       @text.setText message
