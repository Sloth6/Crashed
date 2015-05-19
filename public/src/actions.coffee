window.actions =
  knockback:
    image: 'knockback'
    cooldown: 120
    
    start: () ->
      strength = 1000
      game = @
      for enemy in game.enemies
        angle = Math.atan2 enemy.sprite.y, enemy.sprite.x
        enemy.sprite.body.velocity.x = Math.cos(angle) * strength
        enemy.sprite.body.velocity.y = Math.sin(angle) * strength
        enemy.attacking = false
    
  airStrike:
    image: 'airStrike'
    cooldown: 120
    strength: 9999999
    start: (game) ->
      #blow shit up