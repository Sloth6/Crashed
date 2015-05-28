  window.actions =
    knockback:
      image: 'knockback'
      cooldown: 12000
      used: false
      
      start: ->
        return if actions.knockback.used
        @activeAction = null
        actions.knockback.used = true
        setTimeout((-> actions.knockback.used = false), actions.knockback.cooldown)
        strength = 1000
        game = @
        for enemy in game.enemies
          angle = Math.atan2 enemy.sprite.y, enemy.sprite.x
          enemy.sprite.body.velocity.x = Math.cos(angle) * strength
          enemy.sprite.body.velocity.y = Math.sin(angle) * strength
          enemy.attacking = false
      
    airStrike:
      image: 'airstrike'
      cooldown: 120
      strength: 9999999
      startLocation: null
      line: null
      start: ->
        #game is the context (@)
        self = actions.airStrike
        @activeAction = self 
        @input.onDown.add (=> 
          self.startLocation = {x: @mouse.x, y: @mouse.y}
          self.line =  @game.add.graphics 100, 100
          @buildUi.add self.line
          self.line.lineStyle 20, 0xFF0000
          self.line.moveTo @mouse.x, @mouse.y
          console.log "down", @mouse.x, @mouse.y
          true
          )
        @input.onUp.add (=>
          @activeAction = null
          self.line.lineTo @mouse.x, @mouse.y
          # self.line.drawCircle 73, 87, 50
          @ui.add self.line
          @fightUi.visible = false
          @ui.visible = false
          console.log "fightUi", @fightUi.visible
          console.log "buildUi", @buildUi.visible
          console.log "up", @mouse.x, @mouse.y
          setTimeout (-> 
            self.startLocation = null
            self.line.clear), 500
          )
          
      update: ->
        self = actions.airStrike
        return unless self.clickLocation and self.line


