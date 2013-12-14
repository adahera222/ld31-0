define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  Level = require "level"
  LadderActor = require "actors/ladder-actor"

  class LevelActor extends LDFW.Actor
    GRID_SIZE: Level.GRID_SIZE
    constructor: (@app, @game) ->
      super @game

      {@level} = @game
      @ladderActor = new LadderActor @app, @game

    draw: (context) ->
      @_drawPlatforms context
      @_drawLadders context

    _drawPlatforms: (context) ->
      context.fillStyle = "green"
      for platform in @level.platforms
        position = platform.position
          .clone()
          .multiply @GRID_SIZE
        platformWidth = platform.width * @GRID_SIZE

        context.fillRect(
          position.x - @level.scroll.x,
          @app.getHeight() - position.y,
          platformWidth,
          @GRID_SIZE
        )

    _drawLadders: (context) ->
      for ladder in @level.ladders
        position = ladder.position
          .clone()
          .multiply @GRID_SIZE
        ladderHeight = ladder.height * @GRID_SIZE

        @ladderActor.draw context,
          position.x - @level.scroll.x,
          @app.getHeight() - position.y - ladderHeight,


  module.exports = LevelActor
