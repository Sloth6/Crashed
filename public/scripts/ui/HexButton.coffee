class window.HexButton extends Button
  constructor: ({ x, y, r, texture, hoverTexture }) ->
    r ?= 163
    angle = 0
    points = []
    for i in [0...7] by 1
      angle = 1 * Math.PI / 3 * i;
      x_i = Math.floor r * Math.cos(angle)
      y_i = Math.floor r * Math.sin(angle)
      points.push x_i, y_i
    super
    @hitArea = new PIXI.Polygon points

  remove: () =>
    new TWEEN.Tween @
      .to { alpha: 0 }, 300
      .easing TWEEN.Easing.Linear.None
      .onComplete () => super
      .start()



