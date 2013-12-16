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

      @levelIndex = 2
      @levelsCount = 3

      @preloader = new LDFW.Preloader this, [
        "assets/sprites.png",
        "assets/sprites.json",

        "assets/fonts.png",
        "assets/fonts.json",

        "assets/fonts/pixel-16.fnt",
        "assets/fonts/pixel-24.fnt",
        "assets/fonts/pixel-8.fnt",

        "assets/levels/level-0.png",
        "assets/levels/level-1.png",
        "assets/levels/level-2.png"
      ]
      @preloader.on "done", =>

        atlasPNG = @preloader.get "assets/sprites.png"
        atlasJSON = @preloader.get "assets/sprites.json"

        @spriteSheet = new LDFW.TextureAtlas atlasJSON.frames, atlasPNG

        atlasPNG = @preloader.get "assets/fonts.png"
        atlasJSON = @preloader.get "assets/fonts.json"

        @fontsSheet = new LDFW.TextureAtlas atlasJSON.frames, atlasPNG
        @splashScreen = new SplashScreen this

        @screen = @splashScreen

        @run()

      @preloader.load()

    draw: (context) ->
      super

      @screen.draw context

    switchToSplashScreen: ->
      @screen = @splashScreen

    switchToIntroScreen: ->
      @introScreen = new IntroScreen this
      @screen = @introScreen

    switchToInstructionsScreen: ->
      @instructionsScreen = new InstructionsScreen this
      @screen = @instructionsScreen

    switchToGameScreen: ->
      @gameScreen = new GameScreen this
      @screen = @gameScreen

    nextLevel: ->
      @levelIndex++
      @restartGame()

    hasNextLevel: ->
      @levelIndex < @levelsCount - 1

    restartGame: ->
      @gameScreen = new GameScreen this, @levelIndex
      @screen = @gameScreen

  ###
   * Expose App
  ###
  module.exports = App
