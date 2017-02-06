'use strict'
    # window.history.pushState "Game", "", "/game"

random_color = () ->
  letters = '0123456789ABCDEF'
  color = '0x'
  for i in [0...6]
      color += letters[Math.floor(Math.random() * 16)]
  color

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

  create: () ->
    @hex_radius = 40
    @rows = 32
    @cols = 32
    @draw_coords = false
    # @draw_coords = true

    @layout = new Layout('flat', new Point(@hex_radius, @hex_radius*.5), new Point(0, 0))
    @hex_grid = new HexGrid(@rows, @cols)

    @tile_group = game.add.group()

    @world_group = game.add.group()
    @enclosure_group = game.add.group()
    @mouse_down = false

    # Game state
    @state =
      game_mode: 'default'
      income: 0
      money: 0
      enclosures: []

    # console.log "#{TileTypes.empty}"
    @tile_heights = {}
    @tile_heights[TileTypes.empty] = 0
    @tile_heights[TileTypes.short] = 1
    @tile_heights[TileTypes.tall] = 2
    @tile_heights[TileTypes.room] = 2
    @tile_heights[TileTypes.door] = 0
    # @prices =
    #   tile1: 1
    #   tile2: 1

    @client_draw_hex_grid(@hex_grid)

    width = 2000#1.5 * @hex_radius * @rows + @hex_radius
    height = 2000#1.5 * @hex_radius * @cols + @hex_radius
    game.world.setBounds -@hex_radius,-2*@hex_radius, width, height

    tile = @hex_grid.data['16:8']
    # tile = @hex_grid.data['4:2']
    point = @layout.hex_to_pixel(tile.hex)
    @players = [new Player('cody', tile, point)]
    @user = @players[0]
    @world_group.add(@user.sprite)

    window.gameinstance = @
    @game.time.advancedTiming = true # for fps measuring
    game.camera.follow(@user.sprite)

    @highlight = game.add.graphics(0, 0)
    @highlight.lineStyle(4, 0xffff80, .5)
    polygon = @layout.polygon_corners(new HexPoint(0,0,0))
    polygon.push(polygon[0])
    @highlight.drawPolygon(polygon)
    @world_group.add(@highlight)

  client_draw_hex: (graphics, h) ->
    polygon = @layout.polygon_corners(h)
    graphics.drawPolygon(polygon)

    if @draw_coords
      p = @layout.hex_to_pixel(h)
      style = { font: "18px Arial"}#, fill: "#ff0044", wordWrap: true, align: "center", backgroundColor: "#ffff00" };
      str = h.to_string()
      text = game.add.text(p.x, p.y, str, style)
      text.anchor.set(0.5)

  client_draw_hex_grid: (hex_grid) ->
    graphics = game.add.graphics(0, 0)
    graphics.lineStyle(2, 0x056110, 1.0)
    for r in [0...@rows]
      for c in [0...@cols]
        h = qoffset_to_cube(1, {'row':r, 'col':c})
        @client_draw_hex(graphics, h)
    @tile_group.add(graphics)

  client_draw_enclosures: () ->
    @enclosure_group.removeAll()
    graphics = game.add.graphics(0, 0)
    graphics.lineStyle(5, 0x664400)

    for e in @state.enclosures
      # color = random_color()
      color = "0x996600"
      graphics.beginFill(color, .5)

      polygon = (@layout.hex_to_pixel(t.hex) for t in e.perimeter)
      for p in polygon
        p.y -= 20
      graphics.drawPolygon(polygon)

    graphics.endFill()
    @enclosure_group.add(graphics)

  pathfind: (start_tile, end_tile, include_end = true) ->
    impassable = (tile_a, tile_b) =>
      return false if not include_end and tile_b is end_tile
      return true if tile_b.type == TileTypes.room
      Math.abs(@tile_heights[tile_a.type] - @tile_heights[tile_b.type]) > 1

    path = astar.search(@hex_grid, start_tile, end_tile, hex_distance, impassable)
    if not include_end and path.length > 1
      return path[...-1]
    return path

  client_build_tile: (tile) ->
    if tile.sprite
      tile.sprite.destroy()

    if tile.type != TileTypes.empty
      sprite_name = switch tile.type
        when TileTypes.short then 'tile1'
        when TileTypes.tall then 'tile2'
        when TileTypes.room then 'tile3'
        when TileTypes.door then 'tile4'
        else
          throw 'Invalid Tile Type:' + tile.type

      p = @layout.hex_to_pixel(tile.hex)
      tile.sprite = @world_group.create(p.x, p.y, sprite_name)
      scale_factor = (@hex_radius *2) / tile.sprite.width
      tile.sprite.scale.setTo(scale_factor)
      tile.sprite.anchor.set 0.5, 0.75
      tile.sprite.depth = tile.sprite.y

  handle_new_enclosures: () ->
    @state.enclosures = get_enclosures(@hex_grid)
    for e in @state.enclosures
      for t in e.perimeter
        if t.type != TileTypes.door
          t.type = TileTypes.room
        @client_build_tile(t)
    # console.log @state.enclosures.length, 'enclosures found.'
    @client_draw_enclosures()

  tile_action: (tile) ->
    # The main action of clicking a tile, and are next to it
    tile.type = switch tile.type
      when TileTypes.empty then TileTypes.short
      when TileTypes.short then TileTypes.tall
      when TileTypes.tall then TileTypes.empty
      when TileTypes.room then TileTypes.door
      when TileTypes.door then TileTypes.room
      else
        throw 'Invalid Tile Type:' + tile.type

    @client_build_tile(tile)
    @handle_new_enclosures()

  update_left_clicked_tile: (tile) ->

    distance = tile.distance(@user.tile)
    console.log 'left click', distance
    if distance > 1
      new_path = @pathfind(@user.tile, tile, false)
      @players[0].set_path new_path, () =>
        @tile_action(tile)
    else if distance == 1
      @tile_action(tile)

  update_right_clicked_tile: (tile) ->
    new_path = @pathfind(@user.tile, tile)
    @players[0].set_path(new_path)


  update: () ->
    left_click = false
    right_click = false

    mouse_position = @input.getLocalPosition @world_group, game.input.activePointer
    h = @layout.pixel_to_hex(mouse_position)
    tile = @hex_grid.get_hextile(h)
    p = @layout.hex_to_pixel(h)

    # Move highlight.
    @highlight.x = p.x
    @highlight.y = p.y - @tile_heights[tile.type] * 8
    @highlight.depth = p.y

    if game.input.activePointer.isDown
      @mouse_down = game.input.mouse.button + 1

    else if game.input.activePointer.isUp and @mouse_down
      if @mouse_down == 3
        right_click = true
      else
        left_click = true

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
          player.tile = player.current_path.shift()
          p = @layout.hex_to_pixel(player.tile.hex)

          tile_height = @tile_heights[player.tile.type] * 10
          player.sprite.depth += tile_height
          to = {x: p.x, y:p.y-tile_height, depth:p.y + tile_height}
          tween = game.add.tween(player.sprite).to(to, player.speed, "Linear", true, 0)

        else if player.path_end_event
          player.path_end_event()
          player.path_end_event = null

    game.debug.text game.time.fps, 2, 14, "#00ff00"
    @world_group.sort('depth', Phaser.Group.SORT_ASCENDING)
    true
