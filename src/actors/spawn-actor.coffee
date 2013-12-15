define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  class SpawnActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game
      {@spriteSheet} = @app
      @sprite = @spriteSheet.createSprite "world/entrance.png"

      @height = @sprite.getHeight()
      @width = @sprite.getWidth()

    draw: (context, dx, dy) ->
      @sprite.draw context, dx, dy

  module.exports = SpawnActor
