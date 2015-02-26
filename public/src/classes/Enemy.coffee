class window.Enemy
  constructor: ({ group, hex }) ->
    @health = 100
    @speen = 5
    @sprite = group.create hex.x, hex.y, 'enemy'