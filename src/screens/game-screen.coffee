define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  GameStage = require "../stages/game-stage"

  ###
   * GameScreen definition
  ###
  class GameScreen extends LDFW.Screen
    constructor: ->
      super

      # Initialize a new Stage for this screen
      @gameStage = new GameStage @game

    ###
     * Update positions etc.
     * @param  {Number} delta Time passed since the last tick
    ###
    update: (delta) ->
      @gameStage.update delta
      return

    ###
     * Draw the stage
     * @param  {Canvas2DContext} context
    ###
    draw: (context) ->
      context.fillStyle = "#49A0E8"
      context.fillRect 0, 0, context.canvas.width, context.canvas.height

      @gameStage.draw context
      return

  ###
   * Expose GameScreen
  ###
  module.exports = GameScreen
