class Enemy extends Unit
  constructor: ({ q, r, health, speed }) ->
    super { q, r, health, speed, texture: textures.enemy }
    @moveTo { q:0, r:0 }, () =>
    	@kill()

window.Enemy = Enemy