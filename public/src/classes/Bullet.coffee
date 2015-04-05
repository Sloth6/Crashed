class window.Bullet
	constructor: (@game, x, y, angle) ->
		# View
		@sprite = @game.bulletGroup.create x, y, 'bullet'
		@sprite.anchor.set 0.5, 0.5
		@sprite.scale.set(0.4, 0.4)


		# State
		@speed = 1500
		@strength = 50
		@health = 1
		@sprite.name = 'bullet'
		@sprite.container = @
		
		# Physics
		@game.physics.p2.enable @sprite, false
		@sprite.body.setCircle 2

		@sprite.body.setCollisionGroup @game.bulletCG
		@sprite.body.collides [ @game.enemyCG ]
		@sprite.body.data.shapes[0].sensor = true
		@sprite.body.collideWorldBounds = true
		# @sprite.body.onBeginContact.add (b) => @game.bulletHit @sprite, b.sprite
		
		
		@sprite.body.rotation = angle
		@sprite.body.velocity.x = Math.cos(angle) * @speed
		@sprite.body.velocity.y = Math.sin(angle) * @speed