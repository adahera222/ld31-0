define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  Game = require "game"
  GameStage = require "../stages/game-stage"
  WinningStage = require "../stages/winning-stage"
  LosingStage = require "../stages/losing-stage"

  ###
   * GameScreen definition
  ###
  class GameScreen extends LDFW.Screen
    constructor: (@app, @levelIndex) ->
      super

      @game = new Game @app
      window.game = @game
      @gameStage = new GameStage @app, @game

      @winningStage = new WinningStage @app, @game
      @losingStage = new LosingStage @app, @game

      @game.level.parse()
      @game.spawnPlayer()

      @game.run()

    ###
     * Update positions etc.
     * @param  {Number} delta Time passed since the last tick
    ###
    update: (delta) ->
      @game.update delta
      unless @game.ended
        @gameStage.update delta
      else
        if @game.winner is @game.player
          @winningStage.update delta
        else
          @losingStage.update delta

      return

    ###
     * Draw the stage
     * @param  {Canvas2DContext} context
    ###
    draw: (context) ->
      @gameStage.draw context

      if @game.ended
        if @game.winner is @game.player
          @winningStage.draw context
        else
          @losingStage.draw context

      return

  ###
   * Expose GameScreen
  ###
  module.exports = GameScreen
