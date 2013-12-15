define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  Game = require "game"
  GameStage = require "../stages/game-stage"

  ###
   * GameScreen definition
  ###
  class GameScreen extends LDFW.Screen
    constructor: (@app) ->
      super

      @game = new Game @app
      window.game = @game
      @gameStage = new GameStage @app, @game

      @game.level.parse()
      @game.spawnPlayer()

    ###
     * Update positions etc.
     * @param  {Number} delta Time passed since the last tick
    ###
    update: (delta) ->
      @game.update delta
      @gameStage.update delta
      return

    ###
     * Draw the stage
     * @param  {Canvas2DContext} context
    ###
    draw: (context) ->
      @gameStage.draw context
      return

  ###
   * Expose GameScreen
  ###
  module.exports = GameScreen
