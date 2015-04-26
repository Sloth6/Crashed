
Crashed.Preloader = function (game) {

  this.background = null;
  this.preloadBar = null;

  this.ready = false;

};

Crashed.Preloader.prototype = {

  preload: function () {

    //  These are the assets we loaded in Boot.js
    //  A nice sparkly background and a loading progress bar
    // this.background = this.add.sprite(0, 0, 'preloaderBackground');
    this.add.tileSprite(0, 0, 3000,3000, 'background');
    this.preloadBar = this.add.sprite(window.innerWidth/2, 400, 'loadingBar');
    this.preloadBar.anchor.set(0.5, 0.5);


    //  This sets the preloadBar sprite as a loader sprite.
    //  What that does is automatically crop the sprite from 0 to full-width
    //  as the files below are loaded in.
    this.load.setPreloadSprite(this.preloadBar);

    //  Here we load the rest of the assets our game needs.
    //  As this is just a Project Template I've not provided these assets, swap them for your own.
    this.load.image('background', 'images/mainmenu/background.png');
    // this.load.atlas('playButton', 'images/play_button.png', 'images/play_button.json');
    this.load.spritesheet('playButton', 'images/mainmenu/playButton.png', 326, 287, 2);
    this.load.spritesheet('loadButton', 'images/mainmenu/loadButton.png', 326, 287, 2);

    this.load.spritesheet('instructionsButton', 'images/mainmenu/instructionsButton.png', 326, 287, 2);
    

    // this.load.audio('titleMusic', ['audio/One_More_Time.m4a']);

    this.stage.backgroundColor = '#007236';
    this.load.image('hex', 'images/greenhex.gif');
    this.load.image('minerals', 'images/environment/minerals.gif');
    this.load.image('trees', 'images/environment/trees2.png');
    
    this.load.image('Base', 'images/buildings/base.gif');
    this.load.image('Pylon', 'images/buildings/pylon.gif');

    this.load.image('BasicTower1', 'images/buildings/tower.gif');
    this.load.image('BasicTower2', 'images/buildings/tower.gif');
    this.load.image('BasicTower3', 'images/buildings/tower.gif');

    this.load.image('BombTower1', 'images/buildings/bombTower.gif');
    this.load.image('BombTower2', 'images/buildings/bombTower.gif');

    this.load.image('WallTower1', 'images/buildings/walltower.gif');
    this.load.image('FireTower1', 'images/buildings/firetower.gif');

    this.load.image('Wall', 'images/buildings/wall.gif');
    this.load.image('Collector', 'images/buildings/collector.png');

    this.load.image('powered', 'images/PowerSymbol.jpg');
    this.load.image('hexMenu', 'images/ui/hexMenu.gif');
    this.load.image('menuPartition', 'images/ui/menuPartition.gif');
    this.load.image('sell', 'images/ui/sell.gif');

    this.load.image('enemy', 'images/units/enemy.gif');
    this.load.image('bigEnemy', 'images/units/bigEnemy.gif');
    this.load.image('bullet', 'images/ammo/bullet.gif');
    this.load.image('bomb', 'images/ammo/bomb.gif');

    this.load.image('start', 'images/ui/start.png');
    this.load.image('save', 'images/ui/save.png');
    this.load.image('foo', 'images/ui/upgradeButton.gif');

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
    // this.state.start('Game');
    // if (this.cache.isSoundDecoded('titleMusic') && this.ready == false) {
    //   this.ready = true;
    this.state.start('MainMenu');
    // }

  }

};
