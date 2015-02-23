
Crashed.Game = function (game) {

    //  When a State is added to Phaser it automatically has the following properties set on it, even if they already exist:
    this.game;      //  a reference to the currently running game (Phaser.Game)
    this.add;       //  used to add sprites, text, groups, etc (Phaser.GameObjectFactory)
    this.camera;    //  a reference to the game camera (Phaser.Camera)
    this.cache;     //  the game cache (Phaser.Cache)
    this.input;     //  the global input manager. You can access this.input.keyboard, this.input.mouse, as well from it. (Phaser.Input)
    this.load;      //  for preloading assets (Phaser.Loader)
    this.math;      //  lots of useful common math operations (Phaser.Math)
    this.sound;     //  the sound manager - add a sound, play one, set-up markers, etc (Phaser.SoundManager)
    this.stage;     //  the game stage (Phaser.Stage)
    this.time;      //  the clock (Phaser.Time)
    this.tweens;    //  the tween manager (Phaser.TweenManager)
    this.state;     //  the state manager (Phaser.StateManager)
    this.world;     //  the game world (Phaser.World)
    this.particles; //  the particle manager (Phaser.Particles)
    this.physics;   //  the physics manager (Phaser.Physics)
    this.rnd;       //  the repeatable random number generator (Phaser.RandomDataGenerator)

    //  You can use any of these from any function within this State.
    //  But do consider them as being 'reserved words', i.e. don't create a property for your own game called "world" or you'll over-write the world reference.

};

Crashed.Game.prototype = {

    create: function () {

      //  Modify the world and camera bounds
      game.world.setBounds(-2000, -2000, 4000, 4000);

      for (var i = 0; i < 100; i++)
      {
          game.add.sprite(game.world.randomX, game.world.randomY, 'mushroom');
      }

      game.add.text(600, 800, "- phaser -", { font: "32px Arial", fill: "#330088", align: "center" });

      d = game.add.sprite(0, 0, 'phaser');
      d.anchor.setTo(0.5, 0.5);

      cursors = game.input.keyboard.createCursorKeys();
    },

    update: function () {
      if (cursors.up.isDown) {
        game.camera.y -= 4;
      }

      else if (cursors.down.isDown){
        game.camera.y += 4;
      }

      if (cursors.left.isDown){
        game.camera.x -= 4;
      }

      else if (cursors.right.isDown) {
        game.camera.x += 4;
      }
    },

    quitGame: function (pointer) {
        //  Here you should destroy anything you no longer need.
        //  Stop music, delete sprites, purge caches, free resources, all that good stuff.

        //  Then let's go back to the main menu.
        this.state.start('MainMenu');
    }
};


// class Crashed.Game
//   constructor: (@game) ->
//   #  When a State is added to Phaser it automatically has the following properties set on it, even if they already exist:
//     @game      #  a reference to the currently running game (Phaser.Game)
//     @add       #  used to add sprites, text, groups, etc (Phaser.GameObjectFactory)
//     @camera    #  a reference to the game camera (Phaser.Camera)
//     @cache     #  the game cache (Phaser.Cache)
//     @input     #  the global input manager. You can access @input.keyboard, @input.mouse, as well from it. (Phaser.Input)
//     @load      #  for preloading assets (Phaser.Loader)
//     @math      #  lots of useful common math operations (Phaser.Math)
//     @sound     #  the sound manager - add a sound, play one, set-up markers, etc (Phaser.SoundManager)
//     @stage     #  the game stage (Phaser.Stage)
//     @time      #  the clock (Phaser.Time)
//     @tweens    #  the tween manager (Phaser.TweenManager)
//     @state     #  the state manager (Phaser.StateManager)
//     @world     #  the game world (Phaser.World)
//     @particles #  the particle manager (Phaser.Particles)
//     @physics   #  the physics manager (Phaser.Physics)
//     @rnd       #  the repeatable random number generator (Phaser.RandomDataGenerator)

//     #  You can use any of these from any function within this State.
//     #  But do consider them as being 'reserved words', i.e. don't create a property for your own game called "world" or you'll over-write the world reference.
//   create: () ->
//     #  Modify the world and camera bounds
//     game.world.setBounds -2000, -2000, 4000, 4000

//     for i in [0..100] by 1
//       game.add.sprite(game.world.randomX, game.world.randomY, 'mushroom')

//     game.add.text(600, 800, "- phaser -", { font: "32px Arial", fill: "#330088", align: "center" })

//     d = game.add.sprite(0, 0, 'phaser')
//     d.anchor.setTo(0.5, 0.5)

//     cursors = game.input.keyboard.createCursorKeys()

//   update: () ->
//     if cursors.up.isDown
//       game.camera.y -= 4

//     else if cursors.down.isDown
//       game.camera.y += 4

//     if cursors.left.isDown
//       game.camera.x -= 4

//     else if cursors.right.isDown
//       game.camera.x += 4

//   quitGame: (pointer) ->
//     #  Here you should destroy anything you no longer need.
//     #  Stop music, delete sprites, purge caches, free resources, all that good stuff.
//     #  Then let's go back to the main menu.
//     @state.start 'MainMenu'
