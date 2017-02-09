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
        # @cache     #f  the game cache (Phaser.Cache)
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
        @game_common = new GameCommon(@)

        @colors =
            enclosures: '0xf2f2f2'
            background: '0x078c16'
            # red = '0xff5c33'
            roofs:
                solar: '0xffff1a'
                turrets:'0xff9900'
                battery: '0xcc00cc'
                houses: '0x4286f4'

        @room_alpha = .9
        @stage.backgroundColor = @colors.background

        @hex_radius = 40
        @draw_coords = false
        @mouse_down = false
        # @draw_coords = true

        width = 2000#1.5 * @hex_radius * @rows + @hex_radius
        height = 2000#1.5 * @hex_radius * @cols + @hex_radius

        game.world.setBounds -@hex_radius,-2*@hex_radius, width, height
        @layout = new Layout('flat', new Point(@hex_radius, @hex_radius*.5), new Point(0, 0))

        ##### PHASER SPRITE GROUPS
        @tile_group = game.add.group()
        @enclosure_group = game.add.group()
        @world_group = game.add.group()
        @building_group = game.add.group()
        #####



        @draw_tile_grid()

        @local_player = null#@game_common.players[0]

        window.gameinstance = @
        @game.time.advancedTiming = true # for fps measuring

        @highlight = game.add.graphics(0, 0)
        @highlight.lineStyle(4, 0xffff80, .5)
        polygon = @layout.polygon_corners(new HexPoint(0,0,0))
        polygon.push(polygon[0])
        @highlight.drawPolygon(polygon)
        @world_group.add(@highlight)

        #UI
        @bottom_menu = $('#bottomMenu')
        @init_bottom_menu()

        @game_common.new_player('cody')

    update_bottom_menu: () ->
        # Called whenever the player moves to a new tile.
        tile = @local_player.tile
        if @game_common.tile_to_building[tile]
            @bottom_menu.show()
            $('.sub_menu').hide()
            $('.sub_menu.manage_building').show()
        else if @game_common.tile_to_enclosure[tile]
            @bottom_menu.show()
            $('.sub_menu').hide()
            $('.sub_menu.build_building').show()
        else
            @bottom_menu.hide()

    set_local_player: (player) ->
        @new_player(player)
        @local_player = player
        game.camera.follow(@local_player.sprite)

    new_player: (player) ->
        position = @layout.hex_to_pixel(player.tile.hex)
        player.sprite = @world_group.create position.x, position.y, 'enemy'
        player.sprite.anchor.set(0.5, 0.5)

    init_bottom_menu: () ->
        self = @
        $('.sub_menu.build_building').children('.option').click (e) ->
            name = $(@).data().name
            self.game_common.build_building(self.local_player, name)

        $('.sub_menu.manage_building').children('.option').click (e) ->
            name = $(@).data().name
            switch name
                when 'destroy'
                    self.game_common.destroy_building(self.local_player)

    draw_hex: (graphics, h) ->
        polygon = @layout.polygon_corners(h)
        graphics.drawPolygon(polygon)

        if @draw_coords
            p = @layout.hex_to_pixel(h)
            style = { font: "18px Arial"}#, fill: "#ff0044", wordWrap: true, align: "center", backgroundColor: "#ffff00" };
            str = h.to_string()
            text = game.add.text(p.x, p.y, str, style)
            text.anchor.set(0.5)

    draw_tile_grid: () ->
        tile_grid = @game_common.tile_grid
        graphics = game.add.graphics(0, 0)
        graphics.lineStyle(2, 0x056110, 1.0)
        for r in [0...@game_common.rows]
            for c in [0...@game_common.cols]
                h = qoffset_to_cube(1, {'row':r, 'col':c})
                @draw_hex(graphics, h)
        @tile_group.add(graphics)

    enclosures_updated: (enclosures) ->
        @enclosure_group.removeAll()
        graphics = game.add.graphics(0, 0)

        for e in enclosures
            # non-elegant way to not draw f
            if @game_common.tile_to_building[e.interior[0]]
                building = @game_common.tile_to_building[e.interior[0]]
                color = @colors.roofs[building.type]
            else
                color = @colors.enclosures
            graphics.beginFill(color, 1)
            polygon = (@layout.hex_to_pixel(t.hex) for t in e.perimeter)
            graphics.drawPolygon(polygon)

        graphics.endFill()
        @enclosure_group.add(graphics)
        @update_bottom_menu()

    tile_changed: (tile) ->
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

    building_destroyed: (building) ->
        # destroy geometry
        @building_group.remove(building.graphics)
        @enclosures_updated(@game_common.enclosures)
        @update_bottom_menu()

    building_built: (building) ->
        perimeter = building.enclosure.perimeter

        graphics = game.add.graphics(0, 0)
        graphics.beginFill(@colors.roofs[building.type], @room_alpha)
        polygon = (@layout.hex_to_pixel(t.hex) for t in perimeter)

        for i in [0...polygon.length]
            t = perimeter[i]
            polygon[i].y -= @game_common.tile_heights[t.type] * 10
        # for p in polygon
        #     p.y -= @game_common.tile_heights[TileTypes.room] * 10

        graphics.drawPolygon(polygon)

        building.graphics = graphics
        @building_group.add(building.graphics)

        @enclosures_updated(@game_common.enclosures)
        @update_bottom_menu()

    warn: (message) ->
        console.log 'WARNING:', message

    highlight_tile: (mouse_tile) ->
        return unless mouse_tile?
        h = mouse_tile.hex
        p = @layout.hex_to_pixel(h)

        @highlight.x = p.x
        @highlight.y = p.y - @game_common.tile_heights[mouse_tile.type] * 8
        @highlight.depth = p.y

    update_player_position: (player) ->
        p = @layout.hex_to_pixel(player.tile.hex)
        tile_height = @game_common.tile_heights[player.tile.type] * 10
        player.sprite.depth += tile_height
        to = {x: p.x, y:p.y-tile_height, depth:p.y + tile_height}
        tween = game.add.tween(player.sprite).to(to, player.speed, "Linear", true, 0)

        @update_bottom_menu()

    get_click_state: () ->
        left_click = false
        right_click = false

        if game.input.activePointer.isDown
            @mouse_down = game.input.mouse.button + 1

        else if game.input.activePointer.isUp and @mouse_down
            if @mouse_down == 3
                right_click = true
            else
                left_click = true
            @mouse_down = false

        return [left_click, right_click]

    update: () ->
        [left_click, right_click] = @get_click_state()
        mouse_position = @input.getLocalPosition @world_group, game.input.activePointer
        hex = @layout.pixel_to_hex(mouse_position)
        tile = @game_common.tile_grid.get_hextile(hex)

        if tile


            # Move mouse highlight
            @highlight_tile(tile)

            # Handle click events
            if tile and left_click
                @game_common.primary_action(@local_player, tile)
            else if tile and right_click
                @game_common.secondary_action(@local_player, tile)

        @game_common.update()

        game.debug.text game.time.fps, 2, 14, "#00ff00"
        @world_group.sort('depth', Phaser.Group.SORT_ASCENDING)
