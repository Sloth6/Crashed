class window.Building
  constructor: () ->
    @alive = true
    @maxHealth = @health

    @sprite.anchor.set 0.5, 0.5
    @sprite.container = @
    
    @sprite.body.static = true
    @sprite.body.setCollisionGroup @game.buildingCG
    @sprite.body.collides [ @game.enemyCG ]

  kill: () ->
    @alive = false
    @sprite.destroy()
    @game.buildings.remove @
    @hex.building = null
    true

  damage: (n) ->
    @health -= n
    @sprite.alpha = @health / @maxHealth
    @kill() if @health <= 0
    @alive

  repair: () ->
    @health = @maxHealth
    @sprite.alpha = 1.0