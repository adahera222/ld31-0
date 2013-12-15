define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  Mob = require "mob"

  class PackageActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game

      {@package} = @game

      {@spriteSheet} = @app
      @sprite = @spriteSheet.createSprite "package.png"

      @width = @sprite.getWidth()
      @height = @sprite.getHeight()

      @package.width = @width
      @package.height = @height

    update: ->
      super
      @position.set @package.position

    draw: (context) ->
      level = @game.level

      dx = @position.x + 4 - level.scroll.x
      dy = @position.y - @height - level.scroll.y

      @sprite.draw context, dx, dy

  module.exports = PackageActor
