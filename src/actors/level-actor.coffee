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
      context.fillStyle = "green"

      for platform in @level.platforms
        position = platform.position

        context.fillRect(
          position.x * @GRID_SIZE,
          position.y * @GRID_SIZE,
          platform.width * @GRID_SIZE,
          @GRID_SIZE
        )

  module.exports = LevelActor
