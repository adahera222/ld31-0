define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  PlayerActor = require "actors/player-actor"
  PackageActor = require "actors/package-actor"

  ###
   * GameStage definition
  ###
  class GameStage extends LDFW.Stage
    constructor: (@app, @game) ->
      super @game

      @playerActor = new PlayerActor @app, @game
      @addActor @playerActor

      @packageActor = new PackageActor @app, @game
      @addActor @packageActor

    draw: (context) ->
      super

      {width, height} = context.canvas

      context.fillStyle = "#040321"
      context.fillRect 0, 0, width, height

      @playerActor.draw context
      @packageActor.draw context

  ###
   * Expose GameStage
  ###
  module.exports = GameStage
