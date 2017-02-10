# class Player
#     constructor: (@row, @col) ->
#         @health = 100

BuildingTypes =
    solar: 1
    turrets: 2
    battery: 3
    houses: 4
    # room: 5

class Building
    constructor: (id, @type, @enclosure) ->

class GameCommon
    constructor: (@game_specific) ->
        @rows = 32
        @cols = 32

        @players = {} # ID -> object.
        @enemies = {} # ID -> object.

        @next_player_id = 0
        @next_building_id = 0

        @game_mode = 'default'
        @income = 0
        @money = 0
        @enclosures = []

        @buildings = {}
        @tile_to_enclosure = {}
        @tile_to_building = {}

        @tile_grid = new HexGrid(@rows, @cols)

        @tile_heights = {}
        @tile_heights[TileTypes.empty] = 0
        @tile_heights[TileTypes.short] = 1
        @tile_heights[TileTypes.tall] = 2
        @tile_heights[TileTypes.room] = 2
        @tile_heights[TileTypes.door] = 0

        # @astar_tile_costs = {}
        # @astar_tile_costs[TileTypes.empty] = 0
        # @astar_tile_costs[TileTypes.short] = 1
        # @astar_tile_costs[TileTypes.tall] = 2
        # @astar_tile_costs[TileTypes.room] = 2
        # @astar_tile_costs[TileTypes.door] = 0

    starting_tile: () ->
        #TODO for new players find empty tile.
        @tile_grid.data['16:8']

    new_player: (name) ->
        tile = @starting_tile()
        player = new Player(@next_player_id, name, tile)
        @players[player.id] = player
        @next_player_id += 1
        @game_specific.set_local_player(player)
        # @game_specific.new_player(player)

    new_building: (player, type, enclosure) ->
        if type not in BuildingTypes
            throw 'invalid building type'

        building = new Building(type, enclosure)
        @game_specific.new_building(building)

    travel_speed: (player, tile_a, tile_b) ->
        c = 1
        if tile_a.type == tile_b.type
            if tile_a.type == TileTypes.empty
                # no op
            else if tile_a.type == TileTypes.short
                c -= (.5)
        else
            h_diff = Math.abs(@tile_heights[tile_a.type] - @tile_heights[tile_b.type])
            c += h_diff

        return c * player.speed

    pathfind: (player, end_tile, include_end = true) ->
        start_tile = player.tile

        cost = (tile_a, tile_b) => @travel_speed(player, tile_a, tile_b)

        impassable = (tile_a, tile_b) =>
          return false if not include_end and tile_b is end_tile
          return true if tile_b.type == TileTypes.room
          Math.abs(@tile_heights[tile_a.type] - @tile_heights[tile_b.type]) > 1

        path = astar.search(@tile_grid, start_tile, end_tile, hex_distance, impassable, cost)

        if not include_end and path.length > 1
            path[...-1]
        else
            path

    update_enclosures: () ->
        is_partition = (tile) ->
            tile.type != TileTypes.empty
            # [TileTypes.short, TileTypes.room, TileTypes.door].indexOf(tile.type) isnt -1

        @enclosures = get_enclosures(@tile_grid, is_partition)
        @tile_to_enclosure = {}
        for e in @enclosures
          for t in e.interior
            @tile_to_enclosure[t] = e

    tile_action: (player, tile) ->
        # The main action of clicking a tile, while next to it.
        if @tile_to_building[tile]?
            @game_specific.warn('Cannot build inside a building')
        else
            tile.type = switch tile.type
                when TileTypes.empty then TileTypes.short
                when TileTypes.short then TileTypes.tall
                when TileTypes.tall then TileTypes.empty
                when TileTypes.room then TileTypes.door
                when TileTypes.door then TileTypes.room
                else
                    throw 'Invalid Tile Type:' + tile.type

            @update_enclosures()
            @game_specific.enclosures_updated(@enclosures)
            @game_specific.tile_changed(tile)

    move_player: (player, tile, include_end, on_done) ->
        if @tile_to_building[tile]
            @game_specific.warn('Cannot go to building')
            return
        new_path = @pathfind(player, tile, include_end)
        player.set_path(new_path, on_done)

    primary_action: (player, tile) ->
        distance = tile.distance(player.tile)
        # Do we have to walk there?
        if distance > 1
            @move_player(player, tile, false, (() => @tile_action(player, tile)))
        else # Act immediately.
          @tile_action(player, tile)

    secondary_action: (player, tile) ->
        @move_player(player, tile, true)
        # new_path = @pathfind(player, tile)
        # player.set_path(new_path)

    build_building: (player, building_type) ->
        unless BuildingTypes[building_type]?
            throw 'invalid building type: ' + building_type

        tile = player.tile
        enclosure = @tile_to_enclosure[tile]

        building = new Building(@next_building_id, building_type, enclosure)
        @next_building_id += 1

        for t in enclosure.interior
            @tile_to_building[t] = building

        # for t in enclosure.perimeter
        #     t.type = TileTypes.room
        #     @game_specific.tile_changed(t)

        @buildings[building.id] = building

        @game_specific.building_built(building)

    destroy_building: (player) ->
        tile = player.tile
        building = @tile_to_building[tile]

        for tile in building.enclosure.interior
            delete @tile_to_building[tile]

        for t in building.enclosure.perimeter
            t.type = TileTypes.short
            @game_specific.tile_changed(t)

        delete @buildings[building.id]

        @game_specific.building_destroyed(building)

    update: () ->
        # Update players
        for id, player of @players
            if player.current_path?
                if player.current_path.length
                    next_tile = player.current_path[0]# player.current_path.shift()
                    travel_time = @travel_speed(player, player.tile, next_tile)

                    use_update = player.last_move_update < Date.now() - travel_time

                    if use_update
                        player.last_move_update = Date.now()
                        player.tile = next_tile
                        player.current_path.shift() # remove from queue
                        @game_specific.update_player_position(player, player.tile)

                else # Path over.
                    player.current_path = null
                    if player.path_end_event
                        player.path_end_event()
                        player.path_end_event = null


        # Udpate rooms
        # Udpate enemies

        # @dt = new Date().getTime();    //The local timer delta
        # @dte = new Date().getTime();   //The local timer last frame time

    # update: () ->
    #     # this.dt = this.lastframetime ? ( (t - this.lastframetime)/1000.0).fixed() : 0.016

    # build: (player, x, y) ->
    #     # if


    # move_player_to: (player, row, col) ->
    #     path = pathing.shortest_path(player.row, player.col, row, col)

