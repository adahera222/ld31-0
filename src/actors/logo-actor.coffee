define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  Mob = require "mob"

  class LogoActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game

      {@spriteSheet} = @app
      @sprite = @spriteSheet.createSprite "logo.png"

      @width = @sprite.getWidth()
      @height = @sprite.getHeight()

      @position = new LDFW.Vector2 0, -@height
      @toPosition = new LDFW.Vector2 0, 35

    update: ->
      super

      @position.y += (@toPosition.y - @position.y) / 10

    draw: (context) ->
      dx = @app.getWidth() / 2 - @width / 2
      dy = @position.y

      @sprite.draw context, dx, dy

  module.exports = LogoActor
