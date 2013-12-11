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

      @spritesAtlas = @game.getSpritesAtlas()
      @player = @game.getPlayer()

      @sprite = @spritesAtlas.createSprite "player/idle.png"
      @runAnimSprite = @spritesAtlas.createAnimSprite "player/run.png", 2, 0.05
      @offgroundAnimSprite = @spritesAtlas.createAnimSprite "player/offground.png", 3, 0.1

    ###
     * Update the animation sprites
    ###
    update: (delta) ->
      @runAnimSprite.update delta
      @offgroundAnimSprite.update delta

    ###
     * Draw the player sprite
     * @param  {Canvas2D} context
    ###
    draw: (context) ->
      playerPosition = @player.getPosition()

      finalX = playerPosition.getX()
      finalY = playerPosition.getY() + @sprite.getHeight()

      mirrored = @player.direction is -1

      unless @player.onGround
        @offgroundAnimSprite.draw context, finalX, finalY, mirrored
      else if @player.velocity.x isnt 0
        @runAnimSprite.draw context, finalX, finalY, mirrored
      else
        @sprite.draw context, finalX, finalY, mirrored

      return

  ###
   * Expose PlayerActor
  ###
  module.exports = PlayerActor
