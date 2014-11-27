class window.LargeBlob extends Enemy
  constructor: ({ q, r }) ->
    health =  1500
    speed = 2000 * (Math.random()/2 + 0.5)
    texture = textures.largeBlob
    super { q, r, health, speed, texture }

  onMove: (hex) ->
    if hex.building?
      hex.building.destroy()
    if hex.wall?
      hex.wall.destroy()
