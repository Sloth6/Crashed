class window.Hex
  size: 75/2
  width: 75
  height: 75 * Math.sqrt(3)/2
  constructor: ({ game, @group, @click, @x, @y, @q, @r, @type }) ->
    # State
    @building = null #Object
    @selected = false #Boolean
    @enemySpeed = 50

    # view
    @sprite = @group.create @x, @y, @type
    @sprite.width = Hex::width
    @sprite.height = Hex::width
    @sprite.anchor.set 0.5, 0.5
    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add @onInputDown, @
    # @sprite.input.pixelPerfectClick = true
    @sprite.input.useHandCursor = true

    @mytext = new Phaser.Text(game, @x, @y, "")
    game.worldUi.add @mytext
    # @mytext = game.add.text @x, @y, ""
    # @sprite.addChild @mytext
    # @myText.bringToFront()
  
  changeType: (@type) ->
    @sprite.kill()
    @sprite = @group.create @x, @y, @type
    @sprite.width = Hex::width
    @sprite.height = Hex::width
    @sprite.anchor.set 0.5, 0.5
    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add @onInputDown, @
    # @sprite.input.pixelPerfectClick = true
    @sprite.input.useHandCursor = true

  setText: (s) ->
    @mytext.setText s

  onInputDown: () ->
    @click @

  select: () ->
    @selected = true
    @sprite.alpha = 0.5
    console.log @q, @r

  deselect: () ->
    @selected = false
    @sprite.alpha = 1.0

  # Export a non circular json structure for saving
  export: () -> 
    q:@q
    r:@r
    nature: @nature
    building: if @building then @building.name else null