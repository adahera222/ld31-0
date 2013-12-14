define (require, exports, module) ->
  LDFW = require "ldfw"
  Platform = require "level/platform"

  class Level
    GRID_SIZE: 32
    constructor: (@app, @game) ->
      @gravity = new LDFW.Vector2 0, 5000
      @platforms = []

      @platforms.push new Platform @app, @game, {
        position: new LDFW.Vector2 5, 10
        width: 8
      }

    update: (delta) ->
      return

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
            if obj.position.y <= platformPosition.y <= boundaries.y.max
              boundaries.y.max = platformPosition.y

      return boundaries

  module.exports = Level
