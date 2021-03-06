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
  init: (@savedGame) ->
    # Physics
    @game.physics.startSystem Phaser.Physics.P2JS
    @physics.p2.setImpactEvents true
    # @physics.p2.restitution = .99
    # @physics.p2.defaultRestitution = 0.99

    @collectorIncome = 2

    # View
    @stage.backgroundColor = '#89898A'
    @worldScale = 1.0

    @hexMenu = null
    @worldGroup = game.add.group()

    # Hexes
    @hexes = {}
    @hexGroup = game.add.group()
    @worldGroup.add @hexGroup

    # Enemies
    @enemies = []
    @enemyGroup = game.add.group()
    @enemyCG = game.physics.p2.createCollisionGroup()
    @worldGroup.add @enemyGroup

    # roads
    @roads = []
    @roadsGroup = game.add.group()
    @forks = 3
    # @buildingCG = game.physics.p2.createCollisionGroup()
    @worldGroup.add @roadsGroup


    # Player upgrades
    # @playerUpgrades = []

    #in game ui
    @worldUi = game.add.group()
    @worldGroup.add @worldUi

    # UI
    @buildUi = game.add.group() # ui specific to build phase
    @fightUi = game.add.group() # ui specific to fight phase
    @fightUi.visible = false
    @ui = game.add.group() # static ui

    createMenu = () =>
      startButton = @buildUi.create 10, game.camera.height - 150, 'start'
      startButton.fixedToCamera = true
      startButton.inputEnabled = true
      startButton.input.useHandCursor = true
      startButton.events.onInputDown.add @startAttack

      y = 150
      roadCost = 1
      new BuildButton(10, 150, 'road', @)
      # roadButton = @buildUi.create 10, y, "road"
      
      # price = new Phaser.Text game, 60, y, "$"+roadCost
      # price.fixedToCamera = true
      # @buildUi.add price

      # roadButton.height = 50
      # roadButton.width = 50
      # roadButton.fixedToCamera = true
      # roadButton.inputEnabled = true
      # roadButton.input.useHandCursor = true
      # #this monstrousity will wait until I modify phaser library
      # roadButton.events.onInputDown.add () => @buildRoad()
      
      style = { font: "45px Arial" }
      @statsText = game.add.text 50, 10, "", style
      @statsText.fixedToCamera = true
      

      @remainingText = new Phaser.Text game, 10, game.camera.height - 50, "Enemies remaining: #{@enemyCount}", style
      @remainingText.fixedToCamera = true
      @fightUi.add @remainingText

      save = @buildUi.create 10, game.camera.height - 300, 'save'
      save.inputEnabled = true
      save.input.useHandCursor = true
      save.fixedToCamera = true
      save.events.onInputDown.add () =>
        name = prompt "Please give a name", "My saved game."
        window.saveManager.save name, @export() if name

    createMenu()

    # Control
    @upKey = game.input.keyboard.addKey Phaser.Keyboard.W
    @downKey = game.input.keyboard.addKey Phaser.Keyboard.S
    @leftKey = game.input.keyboard.addKey Phaser.Keyboard.A
    @rightKey = game.input.keyboard.addKey Phaser.Keyboard.D

    @time.advancedTiming = true

  create: () ->
    window.history.pushState "Game", "", "/game"
    # Game state
    @mode = 'build' #( attack | build )
    @enemyCount = 0
    @savedGame = @savedGame or window.defaultStart
    @tree_proability = 0.1
    @mineral_proability = 0.1
    @income = 0
    @prices = 
      road: 1
    @rows = 1#@savedGame.rows
    @level = @savedGame.level
    @money = @savedGame.money

    @newHex 0, 0, 'base'
    roadDirections = (dir for dir in hexUtils.directions by 2)
    for [q, r] in roadDirections
      @newHex q, r, 'road'
    for [q,r] in (dir for dir in hexUtils.directions when dir not in roadDirections)
      @newHex q, r, 'default'

    for i in [1..5] by 1
      @expandMap()
    # for hexState in @savedGame.hexes
    #   if hexUtils.hexDistance(hexState, {q:0, r:0 }) <= @rows
    #     hex = @newHex hexState.q, hexState.r, "default"
        # @build hex, window[hexState.building] if hexState.building

    width = Hex::width * @rows * (3 / 4) + game.camera.width / 2
    height = Hex::height * @rows + game.camera.height / 2
    game.world.setBounds -width, -height, 2*width, 2*height

    @camera.x -= @camera.width/2
    @camera.y -= @camera.height/2

    @cursors = game.input.keyboard.createCursorKeys()
    @updateStatsText()
    pathfinding.run @
    @updateIncome()
    window.gameinstance = @
  
  updateIncome: () ->
    districts = hexUtils.getNewDistricts @hexes
    console.log 'new districts', districts
    for district in districts
      @income += district.income

    @updateStatsText()

  newHex: (q, r, type) ->
    x = q * Hex::size * 1.5
    y = (r * Hex::height) + (q * Hex::height / 2)
    hex = new Hex { game: @, group: @hexGroup, click: @clickHex, x, y, q, r, type}
    @hexes["#{q}:#{r}"] = hex
    hex

  expandMap: () ->
    pathfinding.run @
    @rows += 1
    q = -@rows
    r = @rows
    dirs = hexUtils.directions
    for i in [0...6] by 1
      for _ in [0...@rows] by 1
        rand = Math.random()
        type = 'default'
        if rand <  0.1
          type = 'mineralA'
        else if rand < 0.2
          type = 'mineralB'
        @newHex q, r, type
        q = q + dirs[i][0]
        r = r + dirs[i][1]
    for hex in hexUtils.ring @hexes, @rows - 1
      if hex.type is 'road' and hex.closestNeighbor
        fork = Math.random() < 0.5 / 2**hex.forkDepth and @rows > 7
        if fork and (hex.q is 0 or hex.r is 0 or hex.q is -1 * hex.r)
          for dir, index in dirs
            if dir[0] is hex.q - hex.closestNeighbor.q and dir[1] is hex.r - hex.closestNeighbor.r
              roadHexQ = hex.q + dirs[(index + 1) % dirs.length][0]
              roadHexR = hex.r + dirs[(index + 1) % dirs.length][1]
              roadHex = @hexes["#{roadHexQ}:#{roadHexR}"]
              if roadHex in hexUtils.ring @hexes, @rows
                roadHex.changeType "road"
                roadHex.forkDepth = hex.forkDepth + 1
              roadHexQ = hex.q + dirs[(index + 5) % dirs.length][0]
              roadHexR = hex.r + dirs[(index + 5) % dirs.length][1]
              roadHex = @hexes["#{roadHexQ}:#{roadHexR}"]
              if roadHex in hexUtils.ring @hexes, @rows
                roadHex.changeType "road"
                roadHex.forkDepth = hex.forkDepth + 1

        else 
          if fork
            for dir, index in dirs
              curDistance = hexUtils.hexDistance hex, {q:0, r:0}
              nextQ = hex.q + dir[0]
              nextR = hex.r + dir[1]
              nextHex = @hexes["#{nextQ}:#{nextR}"]
              nextDistance = hexUtils.hexDistance nextHex, {q:0, r:0}
              if nextDistance > curDistance
                nextHex.changeType "road"
                nextHex.forkDepth = hex.forkDepth + 1
          roadHexQ = 2*hex.q - hex.closestNeighbor.q
          roadHexR = 2*hex.r - hex.closestNeighbor.r
          roadHex = @hexes["#{roadHexQ}:#{roadHexR}"]
          if roadHex in hexUtils.ring @hexes, @rows
            roadHex.changeType "road"
            if fork
              roadHex.forkDepth = hex.forkDepth + 1
            else
              roadHex.forkDepth = hex.forkDepth

    width = Hex::width * @rows * (3 / 4) + game.camera.width / 2
    height = Hex::height * @rows + game.camera.height / 2
    game.world.setBounds -width, -height, 2*width, 2*height
    true

  clickHex: (hex) =>
    if @activeBuildTool?
      @activeBuildTool.hexClicked hex

  sell: (hex) ->
    @money += hex.building.constructor.cost
    hex.building.remove()
    @updateStatsText()
    true

  build: (hex, type) ->
    hex.changeType type
    while @rows - hexUtils.hexDistance(hex, { q:0, r:0 }) < 7
      @expandMap()

    @money -= @prices[type]
    @updateIncome()
    pathfinding.run @
    
  updateStatsText: () ->
    @statsText.setText "Level: #{@level}  Income:#{@income}  $#{@money} "

  enemiesPerLevel: (n) ->
    n ?= @level
    # Math.floor 10 * Math.pow(1.15, n)
    Math.floor (10 + Math.pow(n, 1.6))

  endAttack: () =>
    @mode = 'build'
    @buildUi.visible = true
    @fightUi.visible = false
    
    @enemies = []
    @level += 1
    @money += @income# + 2*@level
    
    @updateStatsText()

  startAttack: () =>

    @mode = 'attack'

    @buildUi.visible = false
    @fightUi.visible = true

    pathfinding.run @

    @enemyCount = @enemiesPerLevel()
    enemyHealthModifier = Math.pow(@level, 2) / 37

    @aliveEnemies = 0    
    @remainingText.setText "Enemies remaining: #{@aliveEnemies}"

    outerRing = hexUtils.ring(@hexes, @rows)
    starts = outerRing.filter (hex) -> hex.type is 'road'
    steps = Math.ceil(@enemiesPerLevel() / starts.length)


    (myLoop = (i) =>
      setTimeout (()=>
        for hex in starts
          @enemies.push new SmallEnemy(@, hex, enemyHealthModifier)
          @aliveEnemies += 1
          @remainingText.setText "Enemies remaining: #{@aliveEnemies}"
        myLoop(i) if (--i)    # decrement i and call myLoop again if i > 0
      ), 1000
    )(steps)                     # pass the number of iterations as an argument

    true
      
  update: () ->    
    @mouse = @input.getLocalPosition @worldGroup, game.input.activePointer

    @activeBuildTool.update(game.input.activePointer) if @activeBuildTool

    # end wave if no more enemies
    if @enemyCount <= 0 and @mode == 'attack'
      @endAttack()

    e.update() for e in @enemies

    if @cursors.up.isDown
      @worldScale += .05
      @worldScale = Math.min @worldScale, 3
      @worldGroup.scale.setTo @worldScale, @worldScale
      
    else if @cursors.down.isDown
      @worldScale -= .05
      @worldScale = Math.max @worldScale, 0.35
      @worldGroup.scale.setTo @worldScale, @worldScale

    if @upKey.isDown
      game.camera.y -= 8
    else if @downKey.isDown
      game.camera.y += 8
    
    if @leftKey.isDown
      game.camera.x -= 8
    else if @rightKey.isDown
      game.camera.x += 8
    game.debug.text game.time.fps, 2, 14, "#00ff00"
    true

  export: () ->
    hexes = []
    for qr, hex of @hexes
      hexes.push hex.export()
    rows: @rows
    level: @level
    money: @money
    hexes: hexes