class window.Trees extends Hex
  constructor: ({ width, height, q, r, gold }) ->
    @environmentSprite = new PIXI.Sprite textures['trees'+Math.randInt(3)]
    @environmentSprite.anchor.x = 0.5
    @environmentSprite.anchor.y = 0.5
    { x, y } = @qrToxy { q, r, width }
    @environmentSprite.position.x = x
    @environmentSprite.position.y = y
    @environmentSprite.width = width
    @environmentSprite.height = height
    super { width, height, q, r, gold }

  isTrees: () -> true