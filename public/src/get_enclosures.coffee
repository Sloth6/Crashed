class Enclosure
    constructor: (@interior, @perimeter) ->
        #Store two groups of tiles.

# Given a hex, get its cluster
get_enclosure = (tile_grid, tile, is_partition) ->
    return null if tile.enclosure_viewed
    partitions = [] # Collect all roads that border district
    interior = [] # Collect all hexes in district
    is_exterior = false

    verbose = false

    floodFillR = (t) -> # Recursive function that adds to district.
        if is_partition(t)
            partitions.push(t)
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
    is_partition ?= (tile) -> tile.type > 0
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
