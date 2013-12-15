define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  class LadderActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game

      {@spriteSheet} = @app

      @sprite = @spriteSheet.createSprite "world/ladder.png"

    draw: (context, dx, dy, height) ->
      spriteHeight = @sprite.getHeight()
      spritesCount = Math.ceil height / spriteHeight

      for i in [0...spritesCount]
        restHeight = Math.min spriteHeight, spriteHeight + (height - (i + 1) * spriteHeight)

        @sprite.draw context, dx, dy + i * spriteHeight, false, {
          sourceHeight: restHeight,
          destHeight: restHeight
        }

  module.exports = LadderActor
