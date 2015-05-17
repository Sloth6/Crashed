class window.Building
  constructor: () ->
    @alive = true
    @maxHealth = @health

    @sprite.anchor.set 0.5, 0.5
    @sprite.container = @
    
    # physics
    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle @r
    @sprite.body.static = true
    @sprite.body.setCollisionGroup @game.buildingCG
    @sprite.body.collides [ @game.enemyCG ]

  remove: () ->
    @alive = false
    @sprite.destroy()
    @game.buildings.remove @
    @hex.building = null
    true

  destroy: () ->
    @alive = false
    @sprite.alpha = 0.1

    # @sprite.body.enable = false
    # @foo = 
    @sprite.body.destroy()
    @sprite.body = null

  damage: (n) ->
    return unless @alive
    @health -= n
    @sprite.alpha = @health / @maxHealth
    @destroy() if @health <= 0
    @alive

  repair: () ->
    @alive = true
    @health = @maxHealth
    @sprite.alpha = 1.0

    @game.physics.p2.enable @sprite, false
    @sprite.body.setCircle @r
    @sprite.body.static = true
    @sprite.body.setCollisionGroup @game.buildingCG
    @sprite.body.collides [ @game.enemyCG ]

    # @sprite.body = new Phaser.Physics.P2.Body(this.game, object, object.x, object.y, 1);
    # @sprite.body.enable = true
    # @sprite.body.static = true
    # @sprite.body.setCollisionGroup @game.buildingCG
    # @sprite.body.collides [ @game.enemyCG ]