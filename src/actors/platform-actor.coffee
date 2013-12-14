define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  class PlatformActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game

      {@spriteSheet} = @app

      @sprite = @spriteSheet.createSprite "world/platform.png"

    draw: (context, dx, dy, width) ->
      spriteWidth = @sprite.getWidth()
      spritesCount = Math.ceil width / spriteWidth

      for i in [0...spritesCount]
        restWidth = Math.min spriteWidth, spriteWidth + (width - (i + 1) * spriteWidth)

        @sprite.draw context, dx + i * spriteWidth, dy, false, {
          sourceWidth: restWidth,
          destWidth: restWidth
        }

  module.exports = PlatformActor
