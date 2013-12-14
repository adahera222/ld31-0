define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  class LevelActor extends LDFW.Actor
    GRID_SIZE: 32
    constructor: (@app, @game) ->
      super @game

      {@level} = @game

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
          position.x,
          @app.getHeight() - position.y,
          platformWidth,
          @GRID_SIZE
        )

    _drawLadders: (context) ->
      context.fillStyle = "orange"
      for ladder in @level.ladders
        position = ladder.position
          .clone()
          .multiply @GRID_SIZE
        ladderHeight = ladder.height * @GRID_SIZE

        context.fillRect(
          position.x,
          @app.getHeight() - position.y - ladderHeight,
          @GRID_SIZE,
          ladderHeight
        )


  module.exports = LevelActor
