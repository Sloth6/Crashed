window.collisionManager =
  enemyCollision: (game, enemy, collider) ->
    enemyWithEnemy = (enemy1, enemy2) ->
      # console.log(enemy1.sprite.body, enemy2.sprite.body)
      # damage = Math.sqrt((enemy1.sprite.body.velocity.x - enemy2.sprite.body.velocity.x)**2 + (enemy1.sprite.body.velocity.y - enemy2.sprite.body.velocity.y)**2)
      # console.log('enemy to enemy collision did', damage)
      # enemy1.damage damage/20
      # enemy2.damage damage/20
    
    enemyWithBuilding = (enemy, building) ->
      return unless building
      game.buildings.remove building
      building.hex.building = null
      building.kill()
      if building instanceof Buildings.pylon
        game.markPowered()
    
    enemyWithWall = (enemy, wall) ->
      return unless enemy instanceof BigEnemy
      wall_alive = wall.damage enemy.strength
      if not wall_alive
        game.enemies.forEach (e) -> 
          e.newPath = true if e instanceof SmallEnemy
      true

    enemyWithBullet = (enemy, bullet) ->
      enemy.damage bullet.strength
      bullet.sprite.kill()
    enemyWithBomb = (enemy, bullet) ->
      bullet.explode()

    if collider instanceof Enemy
      enemyWithEnemy(enemy, collider)
    else if (collider instanceof Buildings.pylon or
        collider instanceof Buildings.tower or
        collider instanceof Buildings.base or
        collider instanceof Buildings.collector)
      enemyWithBuilding(enemy, collider)
    else if collider instanceof Buildings.wall
      enemyWithWall enemy, collider
    else if collider instanceof Bullet
      enemyWithBullet(enemy, collider)
    else if collider instanceof Bomb
      enemyWithBomb(enemy, collider)
    true