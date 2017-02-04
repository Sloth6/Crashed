'use strict'
    # window.history.pushState "Game", "", "/game"


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
    # @stage.backgroundColor = '#89898A'
    @stage.backgroundColor = '#078c16'
    # @worldScale = 1.0

    # @worldUi = game.add.group()
    # @world_group.add @worldUi

  create: () ->
    @hex_radius = 40
    @rows = 32
    @cols = 32

    @layout = new Layout('flat', new Point(@hex_radius, @hex_radius*.5), new Point(0, 0))
    @hex_grid = new HexGrid(@rows, @cols)

    @tile_group = game.add.group()
    @world_group = game.add.group()
    @mouse_down = false

    # Game state
    @state =
      game_mode: 'default'
      income: 0
      money: 0

    @prices =
      tile1: 1
      tile2: 1

    @client_draw_hex_grid(@hex_grid)

    width = 2000#1.5 * @hex_radius * @rows + @hex_radius
    height = 2000#1.5 * @hex_radius * @cols + @hex_radius
    game.world.setBounds -@hex_radius,-2*@hex_radius, width, height

    t = @hex_grid.data['16:0']#.point
    p = @layout.hex_to_pixel(t.point)
    @players = [new Player('cody', t, p)]
    @user = @players[0]
    @world_group.add(@user.sprite)

    window.gameinstance = @
    @game.time.advancedTiming = true # for fps measuring
    game.camera.follow(@user.sprite)

    @highlight = game.add.graphics(0, 0)
    @highlight.lineStyle(2, 0xffff80, .5)
    polygon = @layout.polygon_corners(new HexPoint(0,0,0))
    polygon.push(polygon[0])
    @highlight.drawPolygon(polygon)

  client_draw_hex: (graphics, h) ->
    polygon = @layout.polygon_corners(h)
    graphics.drawPolygon(polygon)

    # p = @layout.hex_to_pixel(h)
    # style = { font: "18px Arial"}#, fill: "#ff0044", wordWrap: true, align: "center", backgroundColor: "#ffff00" };
    # text = game.add.text(p.x, p.y, h.to_string(), style)
    # text.anchor.set(0.5)

  client_draw_hex_grid: (hex_grid) ->
    graphics = game.add.graphics(0, 0)
    graphics.lineStyle(2, 0x056110, 1.0)
    for r in [0...@rows]
      for c in [0...@cols]
        h = qoffset_to_cube(1, {'row':r, 'col':c})
        @client_draw_hex(graphics, h)
    @tile_group.add(graphics)

  pathfind: (hex_tile_a, hex_tile_b) ->
    impassable = (tile) -> tile.type != 0
    astar.search(@hex_grid, hex_tile_a, hex_tile_b, hex_distance, impassable)

  client_build_tile: (tile) ->
    if tile.sprite
      tile.sprite.destroy()

    if tile.type > 0
      p = @layout.hex_to_pixel(tile.point)

      if tile.type == 1
        sprite_name = 'tile1'
      else
        sprite_name = 'tile2'

      tile.sprite = @world_group.create(p.x, p.y, sprite_name)
      scale_factor = (@hex_radius *2) / tile.sprite.width
      tile.sprite.scale.setTo(scale_factor)
      tile.sprite.anchor.set 0.5, 0.75
      # @world_group.sort('y', Phaser.Group.SORT_ASCENDING)

  build_tile: (tile) ->
    if tile.type < 2
      tile.type += 1
    else
      tile.type -= 1
    @client_build_tile(tile)

  update_left_clicked_tile: (tile) ->
    new_path = @pathfind(@user.tile, tile)
    @players[0].set_path(new_path)

  update_right_clicked_tile: (tile) ->
    distance = tile.distance(@user.tile)
    if distance > 1
      new_path = @pathfind(@user.tile, tile)
      if new_path.length != 0
        @players[0].set_path new_path[...-1], () =>
          @build_tile(tile)
    else if distance == 1
      @build_tile(tile)

  update: () ->
    left_click = false
    right_click = false

    mouse_position = @input.getLocalPosition @world_group, game.input.activePointer
    h = @layout.pixel_to_hex(mouse_position)
    tile = @hex_grid.get_hextile(h)
    p = @layout.hex_to_pixel(h)

    @highlight.x = p.x
    @highlight.y = p.y

    if game.input.activePointer.isDown
      @mouse_down = game.input.mouse.button + 1

    else if game.input.activePointer.isUp and @mouse_down
      if @mouse_down == 3
        left_click = true
      else
        right_click = true
      @mouse_down = false

    # Handle click events
    if tile and left_click
      @update_left_clicked_tile(tile)
    else if tile and right_click
      @update_right_clicked_tile(tile)

    # Update players
    for player in @players
      use_update = player.last_move_update < Date.now() - player.speed
      if use_update
        if player.current_path.length
          player.last_move_update = Date.now()
          next_tile = player.current_path.shift()
          player.tile = next_tile
          p = @layout.hex_to_pixel(next_tile.point)
          tween = game.add.tween(player.sprite).to( p, player.speed, "Linear", true, 0)
        else if player.path_end_event
          player.path_end_event()
          player.path_end_event = null

    game.debug.text game.time.fps, 2, 14, "#00ff00"
    @world_group.sort('y', Phaser.Group.SORT_ASCENDING)
    true
