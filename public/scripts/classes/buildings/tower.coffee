class Collector extends Building
  act: () -> #Collect stuff

class Wall extends Building
  act: () -> #Be a wall

class Pylon extends Building
  act: () ->

class Barracks extends Building
  act: () ->

class Base extends Building
  act: () ->
  onDeath: () ->
    confirm 'YOU ARE BAD'

class Tower extends Building
  act: () ->
    enemy = game.nearestEnemy @hex, 2
    if enemy and enemy.alive and @sprite?
      a = @sprite.position
      b = enemy.sprite.position
      @sprite.rotation = Math.atan2(b.y - a.y, b.x - a.x) + Math.PI/2
      enemy.hurt 2

window.buildings ?= {}
window.buildings.collector = Collector
window.buildings.wall = Wall
window.buildings.pylon = Pylon
window.buildings.tower = Tower
window.buildings.barracks = Barracks
window.buildings.base = Base