define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  ###
   * LosingStage definition
  ###
  class LosingStage extends LDFW.Stage
    constructor: (@app, @game) ->
      super @game

    draw: (context) ->
      {width, height} = context.canvas

      context.fillStyle = "rgba(0, 0, 0, 0.92)"
      context.fillRect 0, 0, width, height

  ###
   * Expose LosingStage
  ###
  module.exports = LosingStage
