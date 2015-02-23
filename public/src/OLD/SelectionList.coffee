class window.SelectionList extends Array
  constructor: () ->
    super
    
  add: (h) => @push h
  
  remove: (h) => @splice (@indexOf h), 1

  clear: () =>
    for s in @
      s.alpha = 1.0
      s.selected = false
    # s.alpha = 1.0 and s.selected = false for s in @
    @length = 0