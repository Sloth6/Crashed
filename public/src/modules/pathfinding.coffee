window.pathfinding =
	foo: (game) ->
		for qr, hex of game.hexes
			if hex.nature is 'minerals'
				d = 0
			else if hex.building instanceof Buildings.Wall
				d = Infinity
						# ...

			# ...
		
