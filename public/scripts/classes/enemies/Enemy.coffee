class window.Enemy extends Unit
  constructor: ({ q, r, health, speed, texture }) ->
    super { q, r, health, speed, texture }
    @moveTo { q:0, r:0 }, () =>
      # @kill()

  kill: () ->
    game.onEnemyDeath @
    game.enemyKdTree.remove @
    super()