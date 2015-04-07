class window.Hex
  constructor: ({ game, group, @click, @x, @y, @q, @r }) ->
    # State
    @building = null #Object
    @nature = null #String
    @minerals = 0
    @selected = false #Boolean
    @powered = false

    # view
    @sprite = group.create @x, @y, 'hex'
    @sprite.anchor.set 0.5, 0.5
    @natureSprite = null #Phaser sprite object
    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add @onInputDown, @
    @sprite.input.pixelPerfectOver = true
    @sprite.input.useHandCursor = true

    @powerSprite = group.create @x, @y, 'powered'
    @powerSprite.visible = false

    if Math.random() < 0.1
      @nature = 'minerals'
      @natureSprite = group.create @x, @y, 'minerals'
      @natureSprite.anchor.set 0.5, 0.5


    

  getCost: () -> 1

  onInputDown: () ->
    @click @

  select: () ->
    @selected = true
    @sprite.alpha = 0.5

  deselect: () ->
    @selected = false
    @sprite.alpha = 1.0
  # qrToxy: ({q, r, width}) ->
  #   size = width/2
  #   x = q * size * 1.5
  #   y =  ((r * (Math.sqrt(3)*size) + (q * Math.sqrt(3)/2 * size))) * .5
  #   { x, y }
  
  # onToggleSelect: () ->
  #   return if @isRocks() or @isTrees()
  #   if @selected
  #     @alpha = .5
  #     game.selected.add @
  #   else
  #     @selected = false
  #     @alpha = 1.0
  #     game.selected.remove @
  
  # hasBuilding: () => @building?

  # isRocks: () -> false
  
  # isTrees: () -> false
  
  # getCost: () => if @isTrees() then 100 else 1
  
  # isWall: () -> @wall?

  # isBuildable: () -> not (@isWall() or @isTrees() or @isRocks() or @building)

  # neighbors: () ->
  #   ([[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, 1]].map ([q, r]) =>
  #     game.hexGrid.getHex q+@q, r+@r).filter((elem) -> !!elem)
  
  # distanceTo: ({ q, r }) ->
  #   (Math.abs(q - @q) + Math.abs(r - @r) + Math.abs(q + r - @q - @r)) / 2
  
  # addBuilding: (@building) =>
  
  # addWall: (@wall) =>
