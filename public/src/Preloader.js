
Crashed.Preloader = function (game) {

  this.background = null;
  this.preloadBar = null;

  this.ready = false;

};

Crashed.Preloader.prototype = {

  preload: function () {

    //  These are the assets we loaded in Boot.js
    //  A nice sparkly background and a loading progress bar
    this.background = this.add.sprite(0, 0, 'preloaderBackground');
    this.preloadBar = this.add.sprite(300, 400, 'preloaderBar');

    //  This sets the preloadBar sprite as a loader sprite.
    //  What that does is automatically crop the sprite from 0 to full-width
    //  as the files below are loaded in.
    this.load.setPreloadSprite(this.preloadBar);

    //  Here we load the rest of the assets our game needs.
    //  As this is just a Project Template I've not provided these assets, swap them for your own.
    this.load.image('titlepage', 'images/mainmenu/background.gif');
    // this.load.atlas('playButton', 'images/play_button.png', 'images/play_button.json');
    this.load.image('playButton', 'images/mainmenu/New.gif');
    
    // this.load.audio('titleMusic', ['audio/One_More_Time.m4a']);

    this.stage.backgroundColor = '#007236';
    this.load.image('hex', 'images/greenhex.gif');
    this.load.image('minerals', 'images/enviornment/minerals.gif');
    
    this.load.image('base', 'images/buildings/base.gif');
    this.load.image('reactor', 'images/buildings/reactor.gif');
    this.load.image('pylon', 'images/buildings/pylon.gif');
    this.load.image('tower', 'images/buildings/tower.gif');
    this.load.image('wall', 'images/buildings/wall.gif');
    this.load.image('collector', 'images/buildings/collector.png');

    this.load.image('powered', 'images/PowerSymbol.jpg');

    this.load.image('enemy', 'images/units/enemy.gif');
    this.load.image('bigEnemy', 'images/units/bigEnemy.gif');
    this.load.image('bullet', 'images/bullet.gif');

    this.load.image('start', 'images/ui/start.png');    

  },

  create: function () {

    //  Once the load has finished we disable the crop because we're going to sit in the update loop for a short while as the music decodes
    this.preloadBar.cropEnabled = false;

  },

  update: function () {

    //  You don't actually need to do this, but I find it gives a much smoother game experience.
    //  Basically it will wait for our audio file to be decoded before proceeding to the MainMenu.
    //  You can jump right into the menu if you want and still play the music, but you'll have a few
    //  seconds of delay while the mp3 decodes - so if you need your music to be in-sync with your menu
    //  it's best to wait for it to decode here first, then carry on.
    
    //  If you don't have any music in your game then put the game.state.start line into the create function and delete
    //  the update function completely.
    
    this.ready = true;
    this.state.start('Game');
    // if (this.cache.isSoundDecoded('titleMusic') && this.ready == false) {
    //   this.ready = true;
      // this.state.start('MainMenu');
    // }

  }

};
