define (require, exports, module) ->
  LDFW = require "ldfw"
  Level = require "level"
  _ = require "underscore"

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

      @knockback = new LDFW.Vector2
      @knockbackXDirection = 1

    update: (delta) ->
      gravityStep = @level.gravity.clone()
      gravityStep.multiply delta

      unless @ignoreGravity
        @velocity.add gravityStep

      velocityStep = @velocity.clone()
      velocityStep.multiply delta

      aspiredPosition = @position
        .clone()
        .add(velocityStep)

      aspiredPosition.x += @knockback.x * @knockbackXDirection
      aspiredPosition.y -= @knockback.y

      @knockback.x -= 100 * delta
      @knockback.y -= 100 * delta

      @knockback.x = Math.max 0, @knockback.x
      @knockback.y = Math.max 0, @knockback.y

      boundaries = @level.getBoundariesForObject this
      @_handleXMovement aspiredPosition, boundaries
      @_handleYMovement aspiredPosition, boundaries

      @position.set aspiredPosition

    _handleXMovement: (position, boundaries) ->
      position.x = Math.max boundaries.x.min, position.x
      position.x = Math.min boundaries.x.max, position.x

    _handleYMovement: (position, boundaries) ->
      if position.y >= boundaries.y.max
        position.y = boundaries.y.max
        @velocity.y = 0
        @onGround = true
      else
        @onGround = false

    _findNextHigherPlatform: ->
      platforms = @level.platforms

      # Find higher platforms
      interestingPlatforms = []
      for platform in platforms
        platformPosition = platform.getRealPosition()

        platformY = platformPosition.y
        if platformY < @position.y
          interestingPlatforms.push platform

      # Sort by Y position
      interestingPlatforms.sort (a, b) ->
        a.position.y - b.position.y

      # Return the nearest platform
      return interestingPlatforms[0]

    _findNextLowerPlatform: (target, excludeOwn = true, xIntersection = false) ->
      platforms = @level.platforms

      additionalCheckDistance = Level.GRID_SIZE / 2
      if excludeOwn
        additionalCheckDistance = -Level.GRID_SIZE / 2

      # Find lower platforms
      interestingPlatforms = []
      for platform in platforms
        platformPosition = platform.getRealPosition()

        platformX = platformPosition.x
        platformY = platformPosition.y
        platformWidth = platform.width * Level.GRID_SIZE

        if platformY > @position.y - additionalCheckDistance
          if not xIntersection or
            (xIntersection and
              not (@position.x > platformX + platformWidth or
                @position.x + @width < platformX))
                  interestingPlatforms.push platform

      if interestingPlatforms.length is 0
        return null

      # Return the nearest platform
      grouped = _.groupBy interestingPlatforms, (o) -> o.position.y
      reversedKeys = Object.keys(grouped).reverse()

      if grouped[reversedKeys[0]].length > 1 and target?
        # We have multiple platforms on this y position
        # Find the best one
        interestingPlatforms = grouped[reversedKeys[0]]
        distX = target.x - @position.x

        # Sort by X (depending on where we want to go)
        interestingPlatforms.sort (a, b) ->
          if distX < 0
            b.position.x - a.position.x
          else
            a.position.x - b.position.x

        # Iterate over the platforms, find the first one
        # that is in the right direction
        for platform in interestingPlatforms
          platformPosition = platform.getRealPosition()
          if (distX > 0 and platformPosition.x > @position.x) or
            distX < 0 and platformPosition.x < @position.x
              return platform

        return null
      else
        return interestingPlatforms[0]


    _findCurrentPlatform: ->
      return @_findNextLowerPlatform(null, false, true) or "floor"

    _isAtPlatformEdge: (platform, direction) ->
      platformPosition = platform.getRealPosition()
      platformWidth = platform.width * Level.GRID_SIZE

      if direction is -1
        platformEdge = platformPosition.x + Level.GRID_SIZE
        return @position.x < platformEdge
      else
        platformEdge = platformPosition.x + platformWidth - Level.GRID_SIZE
        return @position.x > platformEdge

    getRealPosition: -> @position

  module.exports = PhysicsObject
