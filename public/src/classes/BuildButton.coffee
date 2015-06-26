class window.BuildButton
  constructor: (@x, @y, @type, @game) ->
    price = new Phaser.Text game, @x+40, @y, "$"
    @active = false

    @button = @game.buildUi.create @x, @y, @type
    @button.fixedToCamera = true
    @button.inputEnabled = true
    @button.input.useHandCursor = true
    @button.events.onInputDown.add () => @click()
    @button.alpha = 0.5

  click: () ->
    if @active
      @active = false
      @button.alpha = 0.5
      @game.activeBuildTool = null
      @sprite.kill()
    else
      @active = true
      @button.alpha = 1.0
      @game.activeBuildTool = @

      @sprite = @game.buildUi.create @x, @y, @type
      @sprite.fixedToCamera = true
      @sprite.anchor.set 0.5, 0.5

  hexClicked: (hex) ->
    @game.build hex, @type

  update: (mouse) ->
    # console.log mouse.clientX, mouse.clientY
    if @active
      @sprite.fixedToCamera = false
      @sprite.x = mouse.clientX
      @sprite.y = mouse.clientY
      @sprite.fixedToCamera = true
      