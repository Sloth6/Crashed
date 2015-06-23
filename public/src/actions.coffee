  # window.actions =
  #   knockback:
  #     image: 'knockback'
  #     cooldown: 12000
  #     used: false
      
  #     click: ->
  #       return if actions.knockback.used
  #       @activeAction = null
  #       actions.knockback.used = true
  #       setTimeout((-> actions.knockback.used = false), actions.knockback.cooldown)
  #       strength = 1000
  #       game = @
  #       for enemy in game.enemies
  #         angle = Math.atan2 enemy.sprite.y, enemy.sprite.x
  #         enemy.sprite.body.velocity.x = Math.cos(angle) * strength
  #         enemy.sprite.body.velocity.y = Math.sin(angle) * strength
  #         enemy.attacking = false
      
  #   airStrike:
  #     image: 'airstrike'
  #     cooldown: 120
  #     strength: 9999999
  #     width: 50
  #     start: null
  #     end: null
  #     line: null
  #     click: ->
  #       #game is the context (@)
  #       console.log 'click @', @
  #       self = actions.airStrike
  #       return if @activeAction == self
  #       @activeAction = self 
  #       @input.onDown.addOnce (=> 
  #         console.log "down"
  #         self.start = @mouse
  #         self.line = @game.add.graphics 0, 0
  #         @buildUi.add self.line 
  #         self.line.lineStyle self.width, 0xFF0000, 0.5
  #         self.line.moveTo @mouse.x, @mouse.y
  #         true
  #         )
  #       @input.onUp.addOnce (=>
  #         console.log "up"
  #         self.end = @mouse
  #         @activeAction = null
  #         self.line.lineTo @mouse.x, @mouse.y
  #         @fightUi.add self.line 
  #         setTimeout (=> 
  #           self.line.clear()
  #           self.line.lineStyle self.width, 0xFF0000, .75
  #           self.line.moveTo self.start.x, self.start.y
  #           self.line.lineTo self.end.x, self.end.y
  #           setTimeout (=> self.line.clear()), 100
  #           self.strike()
  #           ), 500
  #         )
  #     # distance of (x2, y2) from line formed by (x0, y0) and (x1, y1)
  #     pointLineDistance: (x0, y0, x1, y1, x2, y2)->
  #       num = Math.abs ((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - y2*x1)
  #       denom = ((y2-y1)**2 + (x2-x1)**2)**0.5
  #       num / denom
  #     strike : ->
  #       for enemy in window.gameinstance.enemies
  #         if (@pointLineDistance @start.x, @start.y, @end.x, @end.y, enemy.sprite.x, enemy.sprite.y) < @width
  #           enemy.damage @strength


  #     #   console.log(actions.airStrike.start)
          

