class window.Buildings.tower
	constructor: (@game, hex) ->
		# State
		@health = 100
		@alive = true
		@target = null #Enemy Object
		@fireRate = 500
		@nextFire = 0

		# View
		@sprite = @game.buildingGroup.create hex.x, hex.y, 'tower'
		@sprite.anchor.set 0.5, 0.5

		# Physics
		@game.physics.p2.enable @sprite, false
		@sprite.body.setCircle 30
		@sprite.body.static = true
		@sprite.body.setCollisionGroup @game.buildingCG
		@sprite.body.collides [ @game.enemyCG ]
		# @sprite.body.onBeginContact.add @game.buildingHit, @

	update: () ->
		return unless @alive
		# console.log @target
		if @target? and @target.alive
			angle = Math.atan2(@target.sprite.y - @sprite.y, @target.sprite.x - @sprite.x)
			@sprite.body.rotation = angle + game.math.degToRad 90
			if @game.time.now > @nextFire
				@nextFire = @game.time.now + @fireRate
				new Bullet @game, @sprite.x, @sprite.y, angle
		else
			minD = Infinity
			for e in @game.enemies
				continue unless e.alive
				d = @game.physics.arcade.distanceBetween @sprite, e.sprite
				if d < minD
					minD = d
					@target = e
		true