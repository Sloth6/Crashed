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
    @rows = 9
    @mode = 'build' #( attack | build )
    @enemyCount = 0
    @level = 0
    @money = 200
    @collectorIncome = 10

    @buildingProperties =
      Collector:   { consumption:  1, cost: 10, upgrades: [] }
      Pylon:       { consumption:  0, cost: 4, upgrades: []  }
      Wall:        { consumption:  0, cost: 2, upgrades: []  }
      Base:        { consumption:  0, cost: 0, upgrades: []  }
      BasicTower1:
        consumption: 1, cost: 10, upgrades: ['BombTower1', 'BasicTower2']
      BombTower1:
        consumption: 1, cost: 10, upgrades: ['FireTower1', 'BombTower2']
      FireTower1: { cost: 10, consumption: 10, upgrades: [] }
      BombTower2: { cost: 10, consumption: 10, upgrades: [] } 
      BasicTower2:
        consumption: 1, cost: 10, upgrades: ['WallTower', 'BasicTower3']
      WallTower: { cost: 10, consumption: 10, upgrades: [] }
      BasicTower3: { cost: 10, consumption: 10, upgrades: [] }

    # console.log @buildingProperties
    # View
    @worldScale = .6
    width = 1000
    game.world.setBounds -width, -width, 2*width, 2*width
    @camera.x -= @camera.width/2
    @camera.y -= @camera.height/2
    # @camera.scale.setTo @worldScale, @worldScale

    # Physics
    @game.physics.startSystem Phaser.Physics.P2JS
    @physics.p2.setImpactEvents true
    @physics.p2.restitution = 1

    @hexMenu = null
    @worldGroup = game.add.group()

    # Hexes
    @hexes = {}
    @hexGroup = game.add.group()
    @selectedHexes = []
    @worldGroup.add @hexGroup

    # Enemies
    @enemies = []
    @enemyGroup = game.add.group()
    @enemyCG = game.physics.p2.createCollisionGroup()
    @worldGroup.add @enemyGroup

    # Bullets
    @bulletGroup = game.add.group()
    @bulletCG = game.physics.p2.createCollisionGroup()
    @worldGroup.add @bulletGroup
    
    @bombs = []

    # Buildings
    @buildings = []
    @buildingGroup = game.add.group()
    @buildingCG = game.physics.p2.createCollisionGroup()
    @worldGroup.add @buildingGroup

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

      i = 0
      for type in ['Wall', 'Collector', 'Pylon' , 'BasicTower1']
        button = @buildUi.create 10, (i * 60) + 150, type
        button.height = 50
        button.width = 50
        button.fixedToCamera = true
        button.inputEnabled = true
        button.input.useHandCursor = true
        #this monstrousity will wait until I modify phaser library
        button.events.onInputDown.add ((_type)=> (()=> @clickBuildButton _type))(type)
        i++
      
      style = { font: "45px Arial" }
      @statsText = game.add.text 50, 10, "", style
      @statsText.fixedToCamera = true
      @updateStatsText()

      @remainingText = new Phaser.Text game, 10, game.camera.height - 50, "Enemies remaining: #{@enemyCount}", style
      @remainingText.fixedToCamera = true
      @fightUi.add @remainingText

    # Create the hex field
    start = 0
    end = @rows
    for q in [-@rows..@rows] by 1
      for r in [start..end] by 1
        @newHex q, r
      if q < 0 then start-- else end--

    base = new Buildings.Base(@, @hexes["0:0"])
    @hexes["0:0"].building = base
    @buildings.push base

    createMenu()
    @cursors = game.input.keyboard.createCursorKeys()
    @markPowered()
    # @game.physics.p2.setPostBroadphaseCallback @collided, @
  
  markPowered: () ->
    for coords, h of @hexes
      h.powered = false
      h.powerSprite.visible = false
    checkR = (h) =>
      return if h.powered
      h.powered = true
      h.powerSprite.visible = true
      if (h.building instanceof Buildings.Pylon) or (h.building instanceof Buildings.Base)
        hexUtils.ring(@hexes, 1, h).forEach checkR
        hexUtils.ring(@hexes, 2, h).forEach checkR
        hexUtils.ring(@hexes, 3, h).forEach checkR
    checkR @hexes["0:0"]
  
  newHex: (q, r) ->
    size = (new Phaser.Sprite game, 0, 0, 'hex').width/2
    x = q * size * 1.5
    y = (r * Math.sqrt(3) * size) + (q * Math.sqrt(3)/2 * size)
    hex = new Hex { game: @, group: @hexGroup, click: @clickHex, x, y, q, r}
    @hexes["#{q}:#{r}"] = hex

  expandMap: () ->
    @rows += 1
    q = -@rows
    r = @rows
    directions = [[1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, 1]]
    # @newHex q, r
    for i in [0...6] by 1
      for _ in [0...@rows] by 1
        @newHex q, r
        q = q + directions[i][0]
        r = r + directions[i][1]
    true

  clickHex: (hex) =>
    return if hex.nature is 'trees'
    if @hexMenu?
      @hexMenu.remove()
      @hexMenu = null
      # return
    if @mode == 'build'
      if hex.selected
        @selectedHexes.remove hex
        hex.deselect()
      else
        if hex.building?
          @hexMenu = new HexMenu @, hex
        @selectedHexes.push hex
        hex.select()
    else if @mode == 'attack'
      if hex.selected
        @selectedHexes = []
        hex.deselect()
      else
        for hex in @selectedHexes
          hex.deselect()
        @selectedHexes = [hex]
        hex.select()

  clickUpgradeButton: (hex, type) ->
    console.log 'upgrading to:', type
    hex.building.kill()
    hex.building = null
    @clickBuildButton type

  clickBuildButton: (type) ->
    if buildingValidator.canBuild(@, type) != true
      alert buildingValidator.canBuild @, type
      @selectedHexes.forEach (h) => h.deselect()
      @selectedHexes = []
      return

    @selectedHexes.forEach (hex) =>
      building = new Buildings[type](@, hex)
      hex.building = building
      @buildings.push building
      hex.deselect()
      while @rows - hexUtils.hexDistance(hex, { q:0, r:0 }) < 6
        @expandMap()

    if type == 'Pylon'
      @markPowered()
    @money -= @selectedHexes.length * @buildingProperties[type].cost
    @selectedHexes = []
    @updateStatsText()
    
  updateStatsText: () ->
    @statsText.setText "Level: #{@level}    $#{@money}"

  enemiesPerLevel: (n) ->
    n ?= @level
    Math.floor 20 * Math.pow(1.4, n)

  endAttack: () =>
    @mode = 'build'
    @buildUi.visible = true
    @fightUi.visible = false
    
    @enemies = []
    @level += 1
    for building in @buildings
      if building instanceof Buildings.Collector
        @money += @collectorIncome
    
    @updateStatsText()
    h.deselect() for h in @selectedHexes
    @selectedHexes = []  
  startAttack: () =>
    @mode = 'attack'
    @buildUi.visible = false
    @fightUi.visible = true

    @enemyCount = @enemiesPerLevel()
    enemyHealthModifier = Math.pow(1.4, @level)

    @remainingText.setText "Enemies remaining: #{@enemyCount}"
    outerRing = hexUtils.ring(@hexes, @rows)
    numBig = @enemyCount // 12
    numSmall = @enemyCount - numBig
    hex = outerRing.random()
    for i in [0...numSmall] by 1
      @enemies.push new SmallEnemy(@, hex, enemyHealthModifier)
    for i in [0...numBig] by 1
      h = outerRing.random()
      @enemies.push new BigEnemy(@, hex, enemyHealthModifier)
    true

  enemyHit: (enemySprite, buildingSprite) ->
    # if buildingSprite.name is 'building'
    return unless buildingSprite.container
    building = buildingSprite.container
    return unless (building instanceof Buildings.Pylon or
      building instanceof Buildings.Tower or
      building instanceof Buildings.Base or
      building instanceof Buildings.Collector)
    @buildings.remove building
    building.hex.building = null
    building.kill()
    if building instanceof Buildings.Pylon
      @markPowered()

  bulletHit: (bulletSprite, enemySprite) ->
    enemySprite.container.damage bulletSprite.container.strength
    bulletSprite.kill()
    true

  aoeBulletHit: (bulletSprite, enemySprite) ->
    bullet = bulletSprite.container
    enemy = enemySprite.container
    enemy.damage bullet.strength
    for e in @enemies
      distance = @physics.arcade.distanceBetween e.sprite, bulletSprite
      if distance < bullet.area
        force = 1/Math.pow(distance, 2)
        angle = Math.atan2(e.sprite.x - bullet.sprite.x, e.sprite.y - bullet.sprite.y)
        e.sprite.body.velocity.x += 800 * Math.cos(angle)# * force
        e.sprite.body.velocity.y += 800 * Math.sin(angle)# * force
    bulletSprite.kill()
    true
      
  update: () ->
    upKey = game.input.keyboard.addKey(Phaser.Keyboard.W)
    downKey = game.input.keyboard.addKey(Phaser.Keyboard.S)
    leftKey = game.input.keyboard.addKey(Phaser.Keyboard.A)
    rightKey = game.input.keyboard.addKey(Phaser.Keyboard.D)
    
    # end wave if no more enemies
    if @enemyCount <= 0 and @mode == 'attack'
      @endAttack()

    e.update() for e in @enemies
    b?.update() for b in @bombs

    for b in @buildings
      b.update() if b.update

    if @cursors.up.isDown
      @worldScale += .05
      @worldScale = Math.min @worldScale, 3
      @worldGroup.scale.setTo @worldScale, @worldScale
      
    else if @cursors.down.isDown
      @worldScale -= .05
      @worldScale = Math.max @worldScale, 0.05
      @worldGroup.scale.setTo @worldScale, @worldScale

    if upKey.isDown
      game.camera.y -= 8
    else if downKey.isDown
      game.camera.y += 8
    
    if leftKey.isDown
      game.camera.x -= 8
    else if rightKey.isDown
      game.camera.x += 8
    

    true
