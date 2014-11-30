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
  act: () -> #Be a wall
  sell: () =>
    @hex.wall = null
    game.enemies.forEach (e) -> e.recalculatePath = true
    super()
  destroy: () =>
    @hex.wall = null
    game.enemies.forEach (e) -> e.recalculatePath = true
    super()

class Road extends Building
  constructor: ( hex ) ->
    super hex, 'road'
  act: () ->

class Barracks extends Building
  constructor: ( hex ) ->
    super hex, 'barracks'
    @foodCost = 1
  act: () ->

class Base extends Building
  constructor: ( hex ) ->
    super hex, 'base'
  act: () ->
  onDeath: () ->
    confirm 'YOU ARE BAD'

class Tower extends Building
  constructor: ( hex ) ->
    @dmg = 2
    @range = 4
    @controlled = false
    super hex, 'tower'
    @foodCost = 1
  act: () ->
    if @target? and @target.alive and !@destroyed
      a = @sprite.position
      b = @target.sprite.position
      @sprite.rotation = Math.atan2(b.y - a.y, b.x - a.x) + Math.PI/2
      @target.hurt @dmg
    else
      @target = game.nearestEnemy @hex, @range
      # console.log @target
      # if enemy and enemy.alive and @sprite?

window.buildings ?= {}
window.buildings.farm = Farm
window.buildings.collector = Collector
window.buildings.wall = Wall
window.buildings.road = Road
window.buildings.tower = Tower
window.buildings.barracks = Barracks
window.buildings.base = Base
