class Farm extends Building
  constructor: ( hex ) ->
    super hex, 'farm'
    @foodCost = -3

  act: () -> #Collect stuff

class Collector extends Building
  constructor: ( hex ) ->
    super hex, 'collector'
    @foodCost = 1
  act: () -> #Collect stuff
  onEndRound: () ->
    @hex.gold -= 20
    game.addGold 20

class Wall extends Building
  constructor: ( hex ) ->
    super hex, 'wall'
    @removeChildren()
    @sprites = {}
    for pos, texture of textures.walls
      s = new PIXI.Sprite texture
      s.anchor = new PIXI.Point 0.5, 0.5
      @sprites[pos] = s
      @addChild s

  updateTexture: () ->
    dirs = ['bottomRight', 'topRight', 'top', 'topLeft', 'bottomLeft', 'bottom']
    # @wallContainer.children.sort (a, b) =>
    #   if a.hex.q < b.hex.q or a.hex.r < b.hex.r
    #     return -1
    #   else if a.hex.q > b.hex.q or a.hex.r > b.hex.r
    #     return 1
    for n, i in @hex.neighbors()
      dir = dirs[i]
      @sprites[dir].visible = !n.isWall()
    true

  sell: () =>
    @hex.wall = null
    game.enemies.each (e) -> e.recalculatePath = true
    super()
    
  destroy: () =>
    @hex.wall = null
    game.enemies.each (e) -> e.recalculatePath = true
    super()

class Road extends Building
  constructor: ( hex ) ->
    super hex, 'road'
  act: () ->


class Base extends Building
  constructor: ( hex ) ->
    super hex, 'base'
  act: () ->
  onDeath: () ->
    console.trace()
    confirm 'YOU ARE BAD'

class Tower extends Building
  constructor: ( hex ) ->
    @dmg = 2
    @range = 3
    @controlled = false
    super hex, 'tower'
    @foodCost = 1
  act: () ->
    if @target? and @target.alive and !@destroyed
      a = @position
      b = @target.position
      @rotation = Math.atan2(b.y - a.y, b.x - a.x) + Math.PI/2
      @target.hurt @dmg
    else
      @target = game.enemies.closestTo @hex, @range
      # console.log @target
      # if enemy and enemy.alive and @sprite?

window.buildingClasses = {}
window.buildingClasses.farm = Farm
window.buildingClasses.collector = Collector
window.buildingClasses.wall = Wall
window.buildingClasses.road = Road
window.buildingClasses.tower = Tower
window.buildingClasses.base = Base