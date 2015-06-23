class window.Hex
  size: 75/2
  width: 75
  height: 75 * Math.sqrt(3)/2
  constructor: ({ game, group, @click, @x, @y, @q, @r, @type }) ->
    # State
    @building = null #Object
    @selected = false #Boolean
    @enemySpeed = 10

    # view
    @sprite = group.create @x, @y, @type
    @sprite.width = Hex::width
    @sprite.height = Hex::width
    @sprite.anchor.set 0.5, 0.5
    @natureSprite = null #Phaser sprite object
    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add @onInputDown, @
    @sprite.input.pixelPerfectClick = true
    @sprite.input.useHandCursor = true

    @powerSprite = group.create @x, @y, 'powered'
    @powerSprite.visible = false
    @powerSprite.alpha = 0.4
    @powerSprite.anchor.set 0.5, 0.5

    @mytext = new Phaser.Text(game, @x, @y, "")
    game.worldUi.add @mytext
    # @mytext = game.add.text @x, @y, ""
    # @sprite.addChild @mytext
    # @myText.bringToFront()

    switch @nature
      when 'minerals'
        @natureSprite = group.create @x, @y, 'minerals'
        @natureSprite.anchor.set 0.5, 0.5
      when 'trees'
        @natureSprite = group.create @x, @y, 'trees'
        @natureSprite.anchor.set 0.5, 0.5
        # @natureSprite.scale.set 0.15, 0.2
    if @natureSprite
      @natureSprite.width = Hex::width
      @natureSprite.height = Hex::width
  
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