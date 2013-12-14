define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  class PlayerActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game

      @player = @game.player
      @dataObject = @player

      @width = 32
      @height = 64

    update: ->
      super
      @position.set @player.position

    draw: (context) ->
      context.fillStyle = "red"
      context.fillRect @position.x, @position.y - @height, @width, @height

    intersectsWith: (actor) ->
      return not (actor.position.x > @position.x + @width or
        actor.position.x + actor.width < @position.x or
        actor.position.y > @position.y + @height or
        actor.position.y + actor.height < @position.y)

  module.exports = PlayerActor
