define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  GameScreen = require "./screens/game-screen"

  ###
   * App definition
  ###
  class App extends LDFW.Game
    constructor: ->
      super

      @preloader = new LDFW.Preloader this, [
        "assets/sprites.png",
        "assets/sprites.json",

        "assets/levels/level-0.png"
      ]
      @preloader.on "done", =>

        atlasPNG = @preloader.get "assets/sprites.png"
        atlasJSON = @preloader.get "assets/sprites.json"

        @spriteSheet = new LDFW.TextureAtlas atlasJSON.frames, atlasPNG

        @screen = new GameScreen this

        @run()

      @preloader.load()

    draw: (context) ->
      super

      @screen.draw context

  ###
   * Expose App
  ###
  module.exports = App
