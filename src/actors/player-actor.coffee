define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  ###
   * PlayerActor definition
  ###
  class PlayerActor extends LDFW.Actor
    constructor: ->
      super

      # Get the sprites atlas from our game
      @spritesAtlas = @game.getSpritesAtlas()

      # Create a new sprite from the atlas
      @sprite = @spritesAtlas.createSprite "player/idle.png"

    ###
     * Draw the player sprite
     * @param  {Canvas2D} context
    ###
    draw: (context) ->
      @sprite.draw context, 0, 0
      return

  ###
   * Expose PlayerActor
  ###
  module.exports = PlayerActor
