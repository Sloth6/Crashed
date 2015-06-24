class window.District
  constructor: (@perimeter, @interior, @name) ->
    @income = 0
    for hex in @interior
      hex.setText @name
      if hex.type in ['mineralA', 'mineralB']
        hex.sprite.alpha = 1.0
        @income += 1
      # ...
    
