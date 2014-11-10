class Collector extends Building
  act: () -> #Collect stuff

class Wall extends Building
  act: () -> #Be a wall

class Pylon extends Building
  act: () ->

class Tower extends Building
  act: () ->
    { enemy, distance } = game.nearestEnemy @hex
    if enemy and enemy.alive
      a = @sprite.position
      b = enemy.sprite.position
      @sprite.rotation = Math.atan2(b.y - a.y, b.x - a.x) + Math.PI/2
      enemy.hurt 2

window.buildings ?= {}
window.buildings.collector = Collector
window.buildings.wall = Wall
window.buildings.pylon = Pylon
window.buildings.tower = Tower