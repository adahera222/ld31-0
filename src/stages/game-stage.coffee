define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  PlayerActor = require "../actors/player-actor"
  CloudsActor = require "../actors/clouds-actor"

  ###
   * GameStage definition
  ###
  class GameStage extends LDFW.Stage
    constructor: ->
      super

      @cloudsActor = new CloudsActor @game
      @addActor @cloudsActor

      @playerActor = new PlayerActor @game
      @addActor @playerActor

      mapJSON = @game.preloader.get "assets/tm-bottom.json"
      mapImage = @game.preloader.get "assets/tiles.png"
      @bottomTileMap = new LDFW.TileMap @game, mapJSON, mapImage

    draw: (context) ->
      @bottomTileMap.draw context

      super

  ###
   * Expose GameStage
  ###
  module.exports = GameStage
