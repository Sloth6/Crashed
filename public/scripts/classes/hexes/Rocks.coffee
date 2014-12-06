class window.Rocks extends Hex
  constructor: ({ width, height, q, r, gold }) ->
    { x, y } = @qrToxy { q, r, width }
    super { width, height, q, r, gold }

    environmentSprite = new PIXI.Sprite textures['rocks'+Math.randInt(3)]
    environmentSprite.anchor = new PIXI.Point .5, .5
    environmentSprite.width = width
    environmentSprite.height = height
    @addChild environmentSprite

  isRocks: () -> true