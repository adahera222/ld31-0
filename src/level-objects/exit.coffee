define (require, exports, module) ->
  LDFW = require "ldfw"
  Level = require "level"

  class Exit
    constructor: (@app, @game, @level, options) ->
      {@position} = options

    getRealPosition: ->
      realPosition = @position
        .clone()
        .multiply @level.constructor.GRID_SIZE # Level.GRID_SIZE didnt work...

      realPosition.y = @app.getHeight() - realPosition.y
      return realPosition

    _findCurrentPlatform: ->
      platforms = @level.platforms

      additionalCheckDistance = -@level.constructor.GRID_SIZE / 2

      position = @getRealPosition()

      # Find lower platforms
      interestingPlatforms = []
      for platform in platforms
        platformPosition = platform.getRealPosition()

        platformX = platformPosition.x
        platformY = platformPosition.y
        platformWidth = platform.width * Level.GRID_SIZE

        if platformY > position.y + additionalCheckDistance and
          not (position.x > platformX + platformWidth or
            position.x + @width < platformX)
              interestingPlatforms.push platform


      # Sort by Y position
      interestingPlatforms.sort (a, b) ->
        b.position.y - a.position.y

      # Return the nearest platform
      return interestingPlatforms[0] || "floor"

  module.exports = Exit
