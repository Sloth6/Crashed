class window.EnemyContainer extends PIXI.DisplayObjectContainer
  constructor: (@smallEnemy, @bigEnemy) ->
    super
    @anchor = new PIXI.Point .5, .5
    @x = window.innerWidth/2
    @y = window.innerHeight/2
  # @enemyContainer.x = window.innerWidth/2
  # @enemyContainer.y = window.innerHeight/2
    # ...

  generate: ( { small, large, total }, getLocation ) =>
    for i in [0..small] by 1
      start = getLocation i
      e = new SmallBlob(start) #add @small.. and wtf??
      @addChild e

    for i in [0..large] by 1
      start = getLocation i
      @addChild new LargeBlob(start)

  closestTo: ( qr, r = Infinity ) =>
    dist = (a) -> Hex::distanceTo.call a, qr
    nearest = null
    minDist = Infinity
    for enemy in @children
      d = dist enemy
      if enemy? and enemy.alive and d <= r and d < minDist
        nearest = enemy
        minDist = d
    nearest

  get: () -> @enemies.filter (e) -> e.alive

  each: (fun) ->
    return unless @children.length
    @children.forEach fun

  count: () =>
    @children.reduce ((s, e) -> s += if e.alive then 1 else 0), 0

