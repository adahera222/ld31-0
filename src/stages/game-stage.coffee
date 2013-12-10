define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  PlayerActor = require "../actors/player-actor"

  ###
   * GameStage definition
  ###
  class GameStage extends LDFW.Stage
    constructor: ->
      super

      @playerActor = new PlayerActor @game
      @addActor @playerActor

  ###
   * Expose GameStage
  ###
  module.exports = GameStage
