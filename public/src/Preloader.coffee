class Crashed.Preloader
  constructor: (game) ->
    @background = null
    @preloadBar = null
    @ready = false

  preload: () ->

    #  These are the assets we loaded in Boot.js
    #  A nice sparkly background and a loading progress bar
    # @background = @add.sprite(0, 0, 'preloaderBackground');
    @add.tileSprite 0, 0, 3000,3000, 'background'
    @preloadBar = @add.sprite window.innerWidth/2, 400, 'loadingBar'
    @preloadBar.anchor.set 0.5, 0.5


    #  This sets the preloadBar sprite as a loader sprite.
    #  What that does is automatically crop the sprite from 0 to full-width
    #  as the files below are loaded in.
    @load.setPreloadSprite @preloadBar

    #  Here we load the rest of the assets our game needs.
    #  As this is just a Project Template I've not provided these assets, swap them for your own.
    @load.image 'background', 'images/mainmenu/background.png'
    # @load.atlas('playButton', 'images/play_button.png', 'images/play_button.json');
    @load.spritesheet 'playButton', 'images/mainmenu/playButton.png', 326, 287, 2
    @load.spritesheet 'loadButton', 'images/mainmenu/loadButton.png', 326, 287, 2

    @load.spritesheet 'instructionsButton', 'images/mainmenu/instructionsButton.png', 326, 287, 2
    
    # @load.audio('titleMusic', ['audio/One_More_Time.m4a']);
    # @stage.backgroundColor = '#007236';
    
    @load.image 'road', 'images/hexes/1.png'
    @load.image 'default', 'images/hexes/2.png'
    @load.image 'mineralA', 'images/hexes/3.png'
    @load.image 'mineralB', 'images/hexes/4.png'
    @load.image 'base', 'images/hexes/6.png'

    @load.image 'hexMenu', 'images/ui/hexMenu.gif'
    @load.image 'menuPartition', 'images/ui/menuPartition.gif'
    @load.image 'sell', 'images/ui/sell.gif'

    @load.image 'enemy', 'images/units/enemy.png'

    @load.image 'start', 'images/ui/start.png'
    @load.image 'save', 'images/ui/save.png'
    @load.image 'foo', 'images/ui/upgradeButton.gif'

  create: () ->
    #  Once the load has finished we disable the crop because we're going to sit in the update loop for a short while as the music decodes
    @preloadBar.cropEnabled = false

  update: () ->
    #  You don't actually need to do this, but I find it gives a much smoother game experience.
    #  Basically it will wait for our audio file to be decoded before proceeding to the MainMenu.
    #  You can jump right into the menu if you want and still play the music, but you'll have a few
    #  seconds of delay while the mp3 decodes - so if you need your music to be in-sync with your menu
    #  it's best to wait for it to decode here first, then carry on.
    
    #  If you don't have any music in your game then put the game.state.start line into the create function and delete
    #  the update function completely.
    
    @ready = true
    # @state.start('Game');
    # if (@cache.isSoundDecoded('titleMusic') && @ready == false) {
    #   @ready = true;
    @state.start 'MainMenu'