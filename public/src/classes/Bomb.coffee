class window.Bomb
	constructor: (@game, @x, @y, angle, @dist) ->
		# View
		@sprite = @game.bulletGroup.create @x, @y, 'bullet'
		@sprite.anchor.set 0.5, 0.5

		# State
		@speed = 600
		@strength = 90
		@area = 60
		@range = 200
		@health = 1
		@sprite.name = 'bomb'
		@sprite.container = @
		
		# Physics
		@game.physics.p2.enable @sprite, false
		@sprite.body.setCircle 5
		@sprite.body.setCollisionGroup @game.bulletCG
		@sprite.body.collides [ @game.enemyCG ]
		@sprite.body.collideWorldBounds = true
		# @sprite.body.onBeginContact.add (b) => @game.aoeBulletHit @sprite, b.sprite
		@sprite.body.rotation = angle
		@sprite.body.velocity.x = Math.cos(angle) * @speed
		@sprite.body.velocity.y = Math.sin(angle) * @speed
		@game.bombs.push @

	explode: () ->
		for e in @game.enemies
      distance = @game.physics.arcade.distanceBetween e.sprite, @sprite
      if distance < @area
        force = 1/Math.pow(distance, 2)
        angle = Math.atan2(e.sprite.x - @sprite.x, e.sprite.y - @sprite.y)
        e.sprite.body.velocity.x += 100 * Math.cos(angle)# * force
        e.sprite.body.velocity.y += 100 * Math.sin(angle)# * force
        e.damage(@strength)
    @sprite.kill()
    @game.bombs.remove @

	update: () ->
		d = ((@sprite.position.x - @x)**2 + (@sprite.position.y - @y)**2)**.5
		@explode() if d >= @dist or d >= @range
