define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  GameScreen = require "./screens/game-screen"

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
   * Expose Game
  ###
  module.exports = Game
