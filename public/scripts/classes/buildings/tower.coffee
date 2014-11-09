class Collector extends Building
  act : () ->

class Wall extends Building
  act : () ->

class Pylon extends Building
  act : () ->

class Tower extends Building
  act : () ->
    @sprite.rotation += 0.05
    #shoot shit

window.buildings ?= {}
window.buildings.collector = Collector
window.buildings.wall = Wall
window.buildings.pylon = Pylon
window.buildings.tower = Tower