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
window.buildings.Collector = Collector
window.buildings.Wall = Wall
window.buildings.Pylon = Pylon
window.buildings.Tower = Tower