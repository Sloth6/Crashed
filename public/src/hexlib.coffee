'use strict'
hex_directions = [[1, 0, -1], [1, -1, 0], [0, -1, 1], [-1, 0, 1], [-1, 1, 0], [0, 1, -1]]
hex_diagonals = [[2, -1, -1], [1, -2, 1], [-1, -1, 2], [-2, 1, 1], [-1, 2, -1], [1, 1, -2]]

class HexGrid
    # A sqare grid of hexagons stored in cubic coordinates.
    constructor: (@rows, @cols) ->
        @data = {}
        for r in [0...@rows]
          for c in [0...@cols]
            h = qoffset_to_cube(1, {'row':r, 'col':c})
            @data[h.hash()] = new HexTile(h)

    in_bounds: (h) ->
        {row, col} = qoffset_from_cube(EVEN, h)
        if col < @cols and col >= 0 and row < @rows and row >= 0
            true
        else
            false

    get_neighbors: (tile) =>
        (@get_hextile(h) for h in tile.hex.neighbors() when @get_hextile(h))

    get_hextile: (h) ->
        if !h
            throw new Error('No h value')
        if not @in_bounds(h)
            return false
        @data[h.hash()]

    # get_data: (h) ->
    #     if not in_bounds(h)
    #         return null
    #     @data[h.hash()]?

    # set_data: (h, k, v) ->
    #     hash = h.hash()
    #     if hash in @data
    #         @data[hash][k] = v
    #     else
    #         @data[hash] = {k: v}

TileTypes =
    empty: 0
    short: 1
    tall: 2
    room: 3
    door: 4

class HexTile
    constructor: (@hex) ->
        #### Game Logic Variables ####
        @type = TileTypes.empty

        #### A star variabels. ####
        @f = 0
        @g = 0
        @h = 0
        @visited = false
        @closed = false
        @_parent = null

        ####### Enclosure finding. #########
        @enclosure_viewed = false
        @enclosure_exterior = false

    distance: (other) ->
        @hex.distance(other.hex)

    equal: (other) ->
        @hex.equal(other.hex)

class HexPoint
    constructor: (@q, @r, @s) ->
        @str = "#{@q}:#{@r}"

    to_string: () -> @str

    hash: () -> @str

    add: (other) ->
        new HexPoint(@q + other.q, @r + other.r, @s + other.s)

    subtract: (other) ->
        new HexPoint(@q - other.q, @r - other.r, @s - other.s)

    neighbor: (direction) ->
        [q, r, s] = hex_directions[direction]
        @add(new HexPoint(q, r, s))

    diagonal_neighbor: (direction) ->
        [q, r, s] = hex_diagonals[direction]
        @add(new HexPoint(q, r, s))

    neighbors: () ->
        (@neighbor(i) for i in [0...6])

    length: () ->
        Math.trunc((Math.abs(@q) + Math.abs(@r) + Math.abs(@s)) / 2)

    distance: (other) ->
        @subtract(other).length()

    equal: (other) ->
        (@q == other.q and @r == other.r and @s == other.s)

    round: () ->
        q = Math.trunc(Math.round(@q))
        r = Math.trunc(Math.round(@r))
        s = Math.trunc(Math.round(@s))
        q_diff = Math.abs(q - @q)
        r_diff = Math.abs(r - @r)
        s_diff = Math.abs(s - @s)
        if (q_diff > r_diff && q_diff > s_diff)
            q = -r - s
        else
            if (r_diff > s_diff)
                r = -q - s
            else
                s = -q - r
        new HexPoint(q, r, s)

hex_distance = (a, b) ->
    a.distance(b)

# tile_distance = (a, b) ->
#     a.point.distance(b.point)

# hex_lerp = (a, b, t) ->
#     new HexPoint(a.q * (1 - t) + b.q * t, a.r * (1 - t) + b.r * t, a.s * (1 - t) + b.s * t)

# hex_linedraw = (a, b) ->
#     N = hex_distance(a, b)
#     a_nudge = Hex(a.q + 0.000001, a.r + 0.000001, a.s - 0.000002)
#     b_nudge = Hex(b.q + 0.000001, b.r + 0.000001, b.s - 0.000002)
#     results = []
#     step = 1.0 / Math.max(N, 1)
#     for (i = 0 i <= N i++)
#         results.push(hex_round(hex_lerp(a_nudge, b_nudge, step * i)))
#     results


############ Function for mappign between coordinate systems. ##################
OffsetCoord = (col, row) ->
    {col: col, row: row}

EVEN = 1
ODD = -1
qoffset_from_cube = (offset, h) ->
    col = h.q
    row = h.r + Math.trunc((h.q + offset * (h.q & 1)) / 2)
    OffsetCoord(col, row)

qoffset_to_cube = (offset, h) ->
    q = h.col
    r = h.row - Math.trunc((h.col + offset * (h.col & 1)) / 2)
    s = -q - r
    new HexPoint(q, r, s)

roffset_from_cube = (offset, h) ->
    col = h.q + Math.trunc((h.r + offset * (h.r & 1)) / 2)
    row = h.r
    OffsetCoord(col, row)

roffset_to_cube = (offset, h) ->
    q = h.col - Math.trunc((h.row + offset * (h.row & 1)) / 2)
    r = h.row
    s = -q - r
    new HexPoint(q, r, s)

################################################################################

Point = Phaser.Point
# class Point
#     constructor: (@x, @y) ->

class Orientation
    # Helper class for Layout
    constructor: (@f0, @f1, @f2, @f3, @b0, @b1, @b2, @b3, @start_angle) ->

class Layout
    # Class for drawing hexes.

    @pointy = new Orientation(Math.sqrt(3.0), Math.sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0, Math.sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0, 0.5)
    @flat = new Orientation(3.0 / 2.0, 0.0, Math.sqrt(3.0) / 2.0, Math.sqrt(3.0), 2.0 / 3.0, 0.0, -1.0 / 3.0, Math.sqrt(3.0) / 3.0, 0.0)

    constructor: (orientation_name, @size, @origin) ->
        if orientation_name == 'pointy'
            @orientation = Layout.pointy
        else if orientation_name == 'flat'
            @orientation = Layout.flat
        else
            throw new Error('Invalid orientation.')

    hex_to_pixel: (h) ->
        M = @orientation
        size = @size
        origin = @origin
        x = (M.f0 * h.q + M.f1 * h.r) * size.x
        y = (M.f2 * h.q + M.f3 * h.r) * size.y
        new Point(x + origin.x, y + origin.y)

    pixel_to_hex: (p) ->
        M = @orientation
        size = @size
        origin = @origin
        pt = new Point((p.x - origin.x) / size.x, (p.y - origin.y) / size.y)
        q = M.b0 * pt.x + M.b1 * pt.y
        r = M.b2 * pt.x + M.b3 * pt.y
        new HexPoint(q, r, -q - r).round()

    hex_corner_offset: (corner) ->
        M = @orientation
        size = @size
        angle = 2.0 * Math.PI * (M.start_angle - corner) / 6
        new Point(size.x * Math.cos(angle), size.y * Math.sin(angle))

    polygon_corners: (h) ->
        corners = []
        center = @hex_to_pixel(h)
        for i in [0...6]
            offset = @hex_corner_offset(i)
            corners.push(new Point(center.x + offset.x, center.y + offset.y))
        corners
