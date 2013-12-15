define (require, exports, module) ->
  LDFW = require "ldfw"
  Level = require "level"

  class PhysicsObject
    constructor: (@app, @game) ->
      {@level} = @game

      @position = new LDFW.Vector2
      @velocity = new LDFW.Vector2 0, 100
      @jumpForce = 1200

      @direction = 1

      @width = 0
      @height = 0

      @onGround = false
      @onLadder = false
      @ignoreGravity = false

    update: (delta) ->
      unless @ignoreGravity
        gravityStep = @level.gravity.clone()
        gravityStep.multiply delta

        @velocity.add gravityStep

      velocityStep = @velocity.clone()
      velocityStep.multiply delta

      aspiredPosition = @position.clone().add velocityStep

      boundaries = @level.getBoundariesForObject this
      @_handleYMovement aspiredPosition, boundaries

      @position.set aspiredPosition

    _handleYMovement: (position, boundaries) ->
      if position.y >= boundaries.y.max
        position.y = boundaries.y.max
        @velocity.y = 0
        @onGround = true
      else
        @onGround = false

    _findNextLowerPlatform: (excludeOwn = true) ->
      platforms = @level.platforms

      additionalCheckDistance = -Level.GRID_SIZE / 2
      if excludeOwn
        additionalCheckDistance = Level.GRID_SIZE

      # Find lower platforms
      interestingPlatforms = []
      for platform in platforms
        platformPosition = platform.position
          .clone()
          .multiply Level.GRID_SIZE

        platformY = @app.getHeight() - platformPosition.y
        if platformY > @position.y + additionalCheckDistance
          interestingPlatforms.push platform

      # Sort by Y position
      interestingPlatforms.sort (a, b) ->
        b.position.y - a.position.y

      # Return the nearest platform
      return interestingPlatforms[0]

    _findCurrentPlatform: ->
      return @_findNextLowerPlatform(false) or "floor"

    _isAtPlatformEdge: (platform, direction) ->
      platformPosition = platform.getRealPosition()
      platformWidth = platform.width * Level.GRID_SIZE

      if direction is -1
        platformEdge = platformPosition.x + Level.GRID_SIZE
        return @position.x < platformEdge
      else
        platformEdge = platformPosition.x + platformWidth - Level.GRID_SIZE
        return @position.x > platformEdge

  module.exports = PhysicsObject
