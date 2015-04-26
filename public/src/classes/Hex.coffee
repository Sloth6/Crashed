class window.Hex
  constructor: ({ game, group, @click, @x, @y, @q, @r, @nature }) ->
    # State
    @building = null #Object
    @minerals = 0
    @selected = false #Boolean
    @powered = false
    @burnDamage = 0

    # view
    @sprite = group.create @x, @y, 'hex'
    @sprite.anchor.set 0.5, 0.5
    @natureSprite = null #Phaser sprite object
    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add @onInputDown, @
    @sprite.input.pixelPerfectClick = true
    @sprite.input.useHandCursor = true

    @powerSprite = group.create @x, @y, 'powered'
    @powerSprite.visible = false

    @mytext = game.add.text @x, @y, ""

    switch @nature
      when 'minerals'
        @natureSprite = group.create @x, @y, 'minerals'
        @natureSprite.anchor.set 0.5, 0.5
      when 'trees'
        @natureSprite = group.create @x, @y, 'trees'
        @natureSprite.anchor.set 0.5, 0.5
        @natureSprite.scale.set 0.15, 0.2
  
  setText: (s) ->
    @mytext.setText s

  getCost: () ->
    if @nature is 'trees' then 3 else 1

  onInputDown: () ->
    @click @

  select: () ->
    @selected = true
    @sprite.alpha = 0.5

  deselect: () ->
    @selected = false
    @sprite.alpha = 1.0

  # Export a non circular json structure for saving
  export: () -> 
    x: @x
    y:@y
    q:@q
    r:@r
    nature: @nature
    building: if @building then @building.name else null