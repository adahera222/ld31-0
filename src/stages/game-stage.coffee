define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  LevelActor = require "actors/level-actor"
  PlayerActor = require "actors/player-actor"
  PackageActor = require "actors/package-actor"

  ###
   * GameStage definition
  ###
  class GameStage extends LDFW.Stage
    constructor: (@app, @game) ->
      super @game

      @levelActor = new LevelActor @app, @game
      @addActor @levelActor

      @playerActor = new PlayerActor @app, @game
      @addActor @playerActor

      @packageActor = new PackageActor @app, @game
      @addActor @packageActor

      @mobActors = [@playerActor]

    update: (delta) ->
      super
      unless @game.package.attachedMob?
        for actor in @mobActors
          if actor.intersectsWith @packageActor
            @packageActor.onIntersect actor.dataObject

    draw: (context) ->
      super

      {width, height} = context.canvas

      context.fillStyle = "#040321"
      context.fillRect 0, 0, width, height

      @levelActor.draw context
      @playerActor.draw context
      @packageActor.draw context

  ###
   * Expose GameStage
  ###
  module.exports = GameStage
