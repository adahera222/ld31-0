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

      # Get the player object from our game
      @player = @game.getPlayer()

      # Create a new sprite from the atlas
      @sprite = @spritesAtlas.createSprite "player/idle.png"

    ###
     * Draw the player sprite
     * @param  {Canvas2D} context
    ###
    draw: (context) ->
      playerPosition = @player.getPosition()

      finalX = playerPosition.getX()
      finalY = playerPosition.getY() + @sprite.getHeight()

      @sprite.draw context, finalX, finalY
      return

  ###
   * Expose PlayerActor
  ###
  module.exports = PlayerActor
