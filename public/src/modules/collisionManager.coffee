window.collisionManager =
  enemyCollision: (enemy, collider) ->
    enemyWithEnemy = (enemy1, enemy2) ->
      console.log(enemy1.sprite.velocity)
      damage = Math.sqrt((enemy1.sprite.velocity.x - enemy2.sprite.velocity.x)**2 + (enemy1.sprite.velocity.y - enemy2.sprite.velocity.y)**2)
      console.log('enemy to enemy collision did', damage)
      enemy1.damage damage * 50
      enemy2.damage damage * 50
    enemyWithBuilding = (enemy, building) ->
      console.log('collision with building')
      return unless building
      @buildings.remove building
      building.hex.building = null
      building.kill()
      if building instanceof Buildings.pylon
        @markPowered()
    enemyWithBullet = (enemy, bullet) ->
      console.log('collision with bullet')
      enemy.damage bullet.strength
      bullet.sprite.kill()
    enemyWithAoEBullet = (enemy, bullet) ->
      console.log('collision withAoEBullet')
      enemy.damage bullet.strength
      for e in @enemies
        distance = @physics.arcade.distanceBetween e.sprite, bullet.sprite
        if distance < bullet.area
          force = 1/Math.pow(distance, 2)
          angle = Math.atan2(e.sprite.x - bullet.sprite.x, e.sprite.y - bullet.sprite.y)
          e.sprite.body.velocity.x += 800 * Math.cos(angle)# * force
          e.sprite.body.velocity.y += 800 * Math.sin(angle)# * force
      bullet.sprite.kill()

    console.log(collider)
    if collider instanceof Enemy
      enemyWithEnemy(enemy, collider)
    if (collider instanceof Buildings.pylon or
        collider instanceof Buildings.tower or
        collider instanceof Buildings.base or
        collider instanceof Buildings.collector)
      enemyWithBuilding(enemy, collider)
    if collider instanceof Bullet
      enemyWithBullet(enemy, collider)
    if collider instanceof AoEBullet
      enemyWithAoEBullet(enemy, collider)
