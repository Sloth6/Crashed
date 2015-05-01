class window.TowerRangeDisplay
  constructor: (@game) ->
    [@w, @h] = [1000, 1000]
    @bmd = @game.add.bitmapData @w, @h
    @draw()
  
  update: () ->
    # @sprite = @game.worldGroup.create -w/2, -h/2, @bmd
    # @sprite.destroy()
    @bmd.clear()
    @sprite.destroy()
    @draw()


  draw: () ->
    towers = @game.buildings.filter (b) -> b instanceof Buildings.Tower    
    @bmd.ctx.globalCompositeOperation = 'xor'
    for t in towers
      x = @w/2 + t.hex.x
      y = @h/2 + t.hex.y
      @bmd.ctx.beginPath()
      @bmd.ctx.arc x, y, t.range, 0, 2 * Math.PI, true
      @bmd.ctx.strokeStyle = '#ff0000'
      @bmd.ctx.lineWidth = 1
      @bmd.ctx.stroke()

    @bmd.ctx.fillStyle = '#ff0000'
    @bmd.ctx.globalCompositeOperation = 'destination-out'
    for t in towers
      x = @w/2 + t.hex.x
      y = @h/2 + t.hex.y
      @bmd.ctx.beginPath()
      @bmd.ctx.arc x, y, t.range-1, 0, 2 * Math.PI, true
      @bmd.ctx.fill()
 
    @sprite = @game.worldGroup.create -@w/2, -@h/2, @bmd