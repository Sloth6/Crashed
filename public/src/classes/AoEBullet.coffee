class window.AoEBullet
	constructor: (@game, x, y, angle) ->
		# View
		@sprite = @game.bulletGroup.create x, y, 'bullet'
		@sprite.anchor.set 0.5, 0.5

		# State
		@speed = 600
		@strength = 60
		@area = 60
		@health = 1
		@sprite.name = 'aoebullet'
		@sprite.container = @
		
		# Physics
		@game.physics.p2.enable @sprite, false
		@sprite.body.setCircle 5
		@sprite.body.setCollisionGroup @game.bulletCG
		@sprite.body.collides [ @game.enemyCG ]
		@sprite.body.collideWorldBounds = true
		@sprite.body.onBeginContact.add (b) => @game.aoeBulletHit @sprite, b.sprite
		
		
		@sprite.body.rotation = angle
		@sprite.body.velocity.x = Math.cos(angle) * @speed
		@sprite.body.velocity.y = Math.sin(angle) * @speed