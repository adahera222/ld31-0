define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  GameScreen = require "screens/game-screen"
  SplashScreen = require "screens/splash-screen"
  IntroScreen = require "screens/intro-screen"
  InstructionsScreen = require "screens/instructions-screen"

  ###
   * App definition
  ###
  class App extends LDFW.Game
    constructor: ->
      super

      @preloader = new LDFW.Preloader this, [
        "assets/sprites.png",
        "assets/sprites.json",

        "assets/fonts.png",
        "assets/fonts.json",

        "assets/fonts/pixel-16.fnt",
        "assets/fonts/pixel-24.fnt",
        "assets/fonts/pixel-8.fnt",

        "assets/levels/level-0.png"
      ]
      @preloader.on "done", =>

        atlasPNG = @preloader.get "assets/sprites.png"
        atlasJSON = @preloader.get "assets/sprites.json"

        @spriteSheet = new LDFW.TextureAtlas atlasJSON.frames, atlasPNG

        atlasPNG = @preloader.get "assets/fonts.png"
        atlasJSON = @preloader.get "assets/fonts.json"

        @fontsSheet = new LDFW.TextureAtlas atlasJSON.frames, atlasPNG

        @gameScreen = new GameScreen this
        @splashScreen = new SplashScreen this
        @introScreen = new IntroScreen this
        @instructionsScreen = new InstructionsScreen this

        @screen = @splashScreen

        @run()

      @preloader.load()

    draw: (context) ->
      super

      @screen.draw context

    switchToIntroScreen: ->
      @screen = @introScreen

    switchToInstructionsScreen: ->
      @screen = @instructionsScreen

    switchToGameScreen: ->
      @screen = @gameScreen

  ###
   * Expose App
  ###
  module.exports = App
