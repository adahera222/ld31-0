define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  Mob = require "mob"

  class PackageActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game

      {@player, @package} = @game

      @width = 32
      @height = 32

    update: ->
      super
      @position.set @package.position

    onIntersect: (obj) ->
      if obj instanceof Mob
        @package.attachTo obj

    draw: (context) ->
      context.fillStyle = "blue"
      context.fillRect @position.x, @position.y - @height, @width, @height

  module.exports = PackageActor
