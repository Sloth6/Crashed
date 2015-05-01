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
    
    maxX = 0
    maxY = 0
    for t in towers
      if Math.abs(t.hex.x + t.range) > maxX
        maxX = Math.abs(t.hex.x + t.range)

      if Math.abs(t.hex.x - t.range) > maxX
        maxX = Math.abs(t.hex.x - t.range)

      if Math.abs(t.hex.y + t.range) > maxY
        maxY = Math.abs(t.hex.y + t.range)

      if Math.abs(t.hex.y - t.range) > maxY
        maxY = Math.abs(t.hex.y - t.range)
    
    @w = 2 * Math.ceil(maxX)+2
    @h = 2 * Math.ceil(maxY)+2
    # @bmd.width = maxX * 2
    # @bmd.height = maxY * 2
    @bmd.resize(@w, @h)
    # console.log {maxX, maxY}

    # @bmd.width = @game.rows.
    @bmd.ctx.globalAlpha = 0.5
    @bmd.ctx.globalCompositeOperation = 'xor'
    for t in towers
      x = @w/2 + t.hex.x
      y = @h/2 + t.hex.y
      @bmd.ctx.beginPath()
      @bmd.ctx.arc x, y, t.range, 0, 2 * Math.PI, true
      @bmd.ctx.strokeStyle = '#ff0000'
      @bmd.ctx.lineWidth = 1
      @bmd.ctx.stroke()

    @bmd.ctx.globalAlpha = 1.0
    @bmd.ctx.fillStyle = '#ff0000'
    @bmd.ctx.globalCompositeOperation = 'destination-out'
    for t in towers
      x = @w/2 + t.hex.x
      y = @h/2 + t.hex.y
      @bmd.ctx.beginPath()
      @bmd.ctx.arc x, y, t.range-1, 0, 2 * Math.PI, true
      @bmd.ctx.fill()
    

    


    @sprite = @game.worldGroup.create -@w/2, -@h/2, @bmd