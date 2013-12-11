define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  GameScreen = require "./screens/game-screen"
  Player = require "./player"

  ###
   * Game definition
  ###
  class Game extends LDFW.Game
    constructor: ->
      super

      # Preload assets
      @preloader = new LDFW.Preloader this, [
        "assets/sprites.json",
        "assets/sprites.png",
        "assets/tiles.json",
        "assets/tiles.png",
        "assets/tm-bottom.json"
      ]
      @preloader.on "done", @_onPreloaded
      @preloader.load()

      @player = new Player this
      @player.setPosition(@getWidth() / 2, @getHeight() / 2)

      @gravity = new LDFW.Vector2 0, 1800

    ###
     * Gets called ~60 times per second. Update positions
     * etc. here
     * @param  {Number} delta
     * @private
    ###
    update: (delta) ->
      super

      # Don't do this. You should actually
      # have a separate `Game` managing class
      # outside of this class that only lives
      # inside your Game Screen.
      #
      # This example will be fixed soon.
      @player.update delta

    ###
     * Gets called as soon as the preloader
     * has preloaded all assets
     * @private
    ###
    _onPreloaded: =>
      # Create a sprites atlas from the preloader
      # JSON and PNG
      spritesJSON = @preloader.get "assets/sprites.json"
      spritesImage = @preloader.get "assets/sprites.png"

      @spritesAtlas = new LDFW.TextureAtlas spritesJSON.frames, spritesImage

      @screen = new GameScreen this
      @run()

    ###
     * Gets the sprites atlas
     * @returns {LDFW.TextureAtlas}
     * @public
    ###
    getSpritesAtlas: -> @spritesAtlas

    ###
     * Gets the player
     * @return {Player}
     * @public
    ###
    getPlayer: -> @player

    ###
     * Gets the gravity
     * @return {LDFW.Vector2}
    ###
    getGravity: -> @gravity

  ###
   * Expose Game
  ###
  module.exports = Game
