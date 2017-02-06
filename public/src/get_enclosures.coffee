class Enclosure
    constructor: (@interior, @perimeter) ->
        #Store two groups of tiles. perimeters tiles are ordered.


order_tiles = (tile_grid, tiles) ->
    # console.log '\nordering'
    tile_set = new Set(tiles) # Only to make lookups O(1)
    t = tiles[0]
    ordered = []
    seen = new Set()

    # console.log (t.hex.to_string() for t in tiles)
    try
        while ordered.length < tiles.length
            found = false
            ordered.push(t)
            seen.add(t)

            if ordered.length == tiles.length
                break

            # console.log 't=', t.hex.to_string()
            # console.log ordered.length,tiles.length
            for n in tile_grid.get_neighbors(t)
                # console.log 'trying ', n.hex.to_string(), not seen.has(n), tile_set.has(n)
                if not seen.has(n) and tile_set.has(n)
                    t = n
                    found = true
                    break

            if !found
                console.log (t.hex.to_string() for t in ordered)
                console.log (t.hex.to_string() for t of ordered)
                throw 'Should not be here!'
        return ordered
    catch e
        console.log e
        return tiles




# Given a hex, get its cluster
get_enclosure = (tile_grid, tile, is_partition) ->
    return null if tile.enclosure_viewed
    seen_partitions = new Set()
    partitions = [] # Collect all roads that border district
    interior = [] # Collect all hexes in district
    is_exterior = false

    verbose = false

    floodFillR = (t) -> # Recursive function that adds to district.
        if is_partition(t) and not seen_partitions.has(t.hex.hash())
            partitions.push(t)
            seen_partitions.add(t.hex.hash())
            t.enclosure_viewed = true

        else if not (t.enclosure_exterior or t.enclosure_viewed)
            t.enclosure_viewed = true
            interior.push(t)

            neighbors = tile_grid.get_neighbors(t)
            if neighbors.length == 6
                for t1 in neighbors
                    floodFillR(t1)
            else
                is_exterior = true
                t.enclosure_exterior = true

    floodFillR(tile)

    if is_exterior
        for t in interior
            t.enclosure_exterior = true
        return null

    return null if (interior.length == 0) or (partitions.length == 0)
    return new Enclosure(interior, partitions)

get_enclosures = (tile_grid, is_partition) ->
    is_partition ?= (tile) -> [TileTypes.short, TileTypes.room, TileTypes.door].indexOf(tile.type) isnt -1
    # console.log(is_partition)
    open = []
    enclosures = []

    for _, t of tile_grid.data
        t.enclosure_viewed = false
        t.enclosure_exterior = false
        if not is_partition(t)
            open.push(t)

    while open.length > 0 #while some hexes are not assigned to enclosures
        current = open.pop()
        enclosure = get_enclosure( tile_grid, current, is_partition)
        if enclosure?
            enclosures.push(enclosure)

    enclosures.filter((x) -> !!x)
    for e in enclosures
        e.perimeter = order_tiles(tile_grid, e.perimeter)
    enclosures



