class Crashed.Game  
    #  When a State is added to Phaser it automatically has the following properties set on it, even if they already exist:
    # game      #  a reference to the currently running game (Phaser.Game)
    # @add       #  used to add sprites, text, groups, etc (Phaser.GameObjectFactory)
    # @camera    #  a reference to the game camera (Phaser.Camera)
    # @cache     #  the game cache (Phaser.Cache)
    # @input     #  the global input manager. You can access @input.keyboard, @input.mouse, as well from it. (Phaser.Input)
    # @load      #  for preloading assets (Phaser.Loader)
    # @math      #  lots of useful common math operations (Phaser.Math)
    # @sound     #  the sound manager - add a sound, play one, set-up markers, etc (Phaser.SoundManager)
    # @stage     #  the game stage (Phaser.Stage)
    # @time      #  the clock (Phaser.Time)
    # @tweens    #  the tween manager (Phaser.TweenManager)
    # @state     #  the state manager (Phaser.StateManager)
    # @world     #  the game world (Phaser.World)
    # @particles #  the particle manager (Phaser.Particles)
    # @physics   #  the physics manager (Phaser.Physics)
    # @rnd       #  the repeatable random number generator (Phaser.RandomDataGenerator)
    #  You can use any of these from any function within this State.
    #  But do consider them as being 'reserved words', i.e. don't create a property for your own game called "world" or you'll over-write the world reference.

  create: () ->
    # Game state
    @hexGroup = game.add.group()
    ui = game.add.group()
    @selectedHexes = []
    @buildings = []
    @enemeis = []
    @rows = 2
    @buildingTypes = [ 'collector', 'farm', 'tower', 'wall' ]

    # View
    @worldScale = 1
    game.world.setBounds -2000, -2000, 4000, 4000
    @camera.x -= @camera.width/2
    @camera.y -= @camera.height/2
    
    createMenu = () =>
      for type, i in @buildingTypes
        button = ui.create 50, (i * 100) + 50, type
        button.height = 50
        button.width = 50
        button.fixedToCamera = true
        button.inputEnabled = true
        button.input.useHandCursor = true
        button.events.onInputDown.add @clickBuildButton, {type}
    
    start = 0
    end = @rows
    size = (new Phaser.Sprite game, 0, 0, 'hex').width/2
    for q in [-@rows..@rows] by 1
      for r in [start..end] by 1
        x = q * size * 1.5
        y = (r * Math.sqrt(3) * size) + (q * Math.sqrt(3)/2 * size)
        new Hex { group: @hexGroup, click: @clickHex, x, y }
      if q < 0 then start-- else end--


    game.add.text(600, 800, "CRASHED", { font: "32px Arial", fill: "#330088", align: "center" })

    createMenu()

    @cursors = game.input.keyboard.createCursorKeys()

  clickHex: (hex) =>
    if hex.selected
      @selectedHexes.remove hex
      hex.deselect()
    else
      @selectedHexes.push hex
      hex.select()

  clickBuildButton: () ->
    type = @type
    console.log type

  update: () ->
    if @cursors.up.isDown
      game.camera.y -= 8
    else if @cursors.down.isDown
      game.camera.y += 8

    if @cursors.left.isDown
      game.camera.x -= 8
    else if @cursors.right.isDown
      game.camera.x += 8

    #zoom
    # if game.input.keyboard.isDown(Phaser.Keyboard.Q)
    #   @worldScale += 0.05
    # else if game.input.keyboard.isDown(Phaser.Keyboard.A)
    #   @worldScale -= 0.05

    # @worldScale = Phaser.Math.clamp(@worldScale, 0.25, 2);
    # game.world.scale.set @worldScale

  quitGame: (pointer) ->
    #  Here you should destroy anything you no longer need.
    #  Stop music, delete sprites, purge caches, free resources, all that good stuff.
    #  Then let's go back to the main menu.
    @state.start 'MainMenu'
