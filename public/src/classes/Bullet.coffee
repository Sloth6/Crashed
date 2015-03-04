class window.Bullet
	constructor: (@game, x, y, angle) ->
		# State
		@health = 100
		@speed = 300
		# View
		@sprite = @game.bulletGroup.create x, y, 'bullet'
		@sprite.anchor.set 0.5, 0.5
		
		
		# Physics
		@game.physics.p2.enable @sprite, false
		@sprite.body.setCircle 5
		@sprite.body.setCollisionGroup @game.bulletCG
		@sprite.body.collides [ @game.enemyCG ]

		@sprite.body.rotation = angle
		@sprite.body.velocity.x = Math.cos(angle) * @speed
		@sprite.body.velocity.y = Math.sin(angle) * @speed