define (require, exports, module) ->
  LDFW = require "ldfw"
  Platform = require "level/platform"
  Ladder = require "level/ladder"

  class Level
    GRID_SIZE: 32
    constructor: (@app, @game) ->
      @gravity = new LDFW.Vector2 0, 5000
      @platforms = []
      @ladders = []

      @platforms.push new Platform @app, @game, {
        position: new LDFW.Vector2 4, 7
        width: 15
      }
      @platforms.push new Platform @app, @game, {
        position: new LDFW.Vector2 10, 14
        width: 8
      }

      @ladders.push new Ladder @app, @game, {
        position: new LDFW.Vector2 9, 0
        height: 7
      }
      @ladders.push new Ladder @app, @game, {
        position: new LDFW.Vector2 14, 7
        height: 7
      }

    isMobTouchingLadder: (mob) ->
      for ladder in @ladders
        ladderPosition = ladder.position
          .clone()
          .multiply @GRID_SIZE
        ladderHeight = ladder.height * @GRID_SIZE
        ladderWidth = @GRID_SIZE

        # Horizontal check
        if mob.position.x + mob.width > ladderPosition.x and
          mob.position.x < ladderPosition.x + ladderWidth

            # Vertical check
            ladderY = (@app.getHeight() - ladderPosition.y)
            if mob.position.y > @app.getHeight() - ladderHeight - ladderPosition.y and
              mob.position.y < ladderY

                intersection = true
                return true

      return false

    getBoundariesForObject: (obj) ->
      boundaries =
        x:
          min: 0
          max: 1000
          object: null
        y:
          min: 0
          max: @app.getHeight()
          object: null

      # Check for platform collisions
      for platform in @platforms
        platformPosition = platform.position
          .clone()
          .multiply @GRID_SIZE
        platformWidth = platform.width * @GRID_SIZE

        # Horizontal check
        if obj.position.x + obj.width > platformPosition.x and
          obj.position.x < platformPosition.x + platformWidth

            # Vertical check
            platformY = (@app.getHeight() - platformPosition.y)
            if obj.position.y <= platformY <= boundaries.y.max
              boundaries.y.max = platformY

      return boundaries

  module.exports = Level
