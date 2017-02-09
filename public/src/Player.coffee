class Player
    constructor: (@id, @name, @tile) ->
        # state
        @health = 100
        @speed = 300 #ms per tile

        @current_path = []
        @last_move_update = Date.now()
        @path_end_event = null

    set_path: (path, path_end_event) ->
        @current_path = path
        @path_end_event = path_end_event

