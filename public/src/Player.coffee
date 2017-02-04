class Player
    constructor: (@name, @tile, point) ->
        # state
        @health = 100
        @speed = 300 #ms per tile

        @current_path = []
        @last_move_update = Date.now()
        @path_end_event = null

        # Client
        @sprite = game.add.sprite point.x, point.y, 'enemy'
        @sprite.anchor.set 0.5, 0.5

    set_path: (path, path_end_event) ->
        @current_path = path
        @path_end_event = path_end_event

