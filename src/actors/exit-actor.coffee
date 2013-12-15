define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  class ExitActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game
      {@spriteSheet} = @app
      @sprite = @spriteSheet.createSprite "world/exit.png"
      @openSprite = @spriteSheet.createSprite "world/exit-open.png"

      @height = @sprite.getHeight()
      @width = @sprite.getWidth()

    draw: (context, dx, dy, open = false) ->
      if open
        @openSprite.draw context, dx, dy
      else
        @sprite.draw context, dx, dy

  module.exports = ExitActor
