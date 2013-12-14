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

    draw: (context, dx, dy) ->
      @sprite.draw context, dx, dy

  module.exports = LadderActor
