class Collector extends Building
  act: () ->

class Wall extends Building
  act: () ->

class Pylon extends Building
  act: () ->

class Tower extends Building
  act: () ->
    if not @happened?
      enemy = game.nearestEnemy(@.hex)[0][0]
      a = @sprite.position
      b = enemy.sprite.position
      @sprite.rotation = Math.atan2(b.y - a.y, b.x - a.x) + Math.PI/2
      # @happened = true
    #shoot shit

window.buildings ?= {}
window.buildings.collector = Collector
window.buildings.wall = Wall
window.buildings.pylon = Pylon
window.buildings.tower = Tower