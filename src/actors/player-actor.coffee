define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  class PlayerActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game

      @player = @game.player

    update: ->
      super
      @position.set @player.position

    draw: (context) ->
      context.fillStyle = "red"
      context.fillRect @position.x, @position.y, 32, 64

  module.exports = PlayerActor
