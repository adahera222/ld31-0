define (require, exports, module) ->
  LDFW = require "ldfw"
  Mob = require "mob"
  Level = require "level"

  class Enemy extends Mob
    interestDistance: 400
    constructor: (@app, @game) ->
      super

      {@player, @package, @level} = @game

      @following = false
      @aiState = "idle"
      @lastAICheck = Date.now()

      @speed = new LDFW.Vector2 250, 250

      @aiSwitchDirection = 0
      @aiSwitchAction = null # run or jump

    update: (delta) ->
      super

      aiCheckInterval = @_getAICheckInterval()
      timePassed = Date.now() - @lastAICheck
      if timePassed >= aiCheckInterval
        @_performAICheck()

        @lastAICheck = Date.now()

      @_performAIAction()

    _stopAIAction: ->
      @velocity.x = 0
      @aiState = "idle"

    _getAICheckInterval: ->
      unless @following
        1000
      else
        300

    _performAICheck: ->
      # Add more logic here:
      #  - As soon as the object of interest is far
      #    away, lose interest in it
      @objectOfInterest = @_findObjectOfInterest()
      if @objectOfInterest and @aiState is "idle"
        @following = true
        @aiState = @_findAIState()

    _findObjectOfInterest: ->
      if @package.attachedMob is @player
        obj = @player
      else
        obj = @package

      distX = Math.pow(@position.x - obj.position.x, 2)
      distY = Math.pow(@position.y - obj.position.y, 2)
      distance = Math.sqrt(distX + distY)

      if distance < @interestDistance
        return obj

      return false

    _findAIState: ->
      distX = @objectOfInterest.position.x - @position.x
      distY = @objectOfInterest.position.y - @position.y
      if distY > 0
        nextPlatform = @_findNextLowerPlatform distX, distY
        if nextPlatform
          newAIState = @_findAIStateForPlatform nextPlatform
          # console.log newAIState, @aiSwitchAction, if @aiSwitchDirection is -1 then "left" else "right"
          return newAIState
        else
          @aiSwitchDirection = if distX < 0 then -1 else 1
          @aiSwitchAction = "run"
          @targetPlatform = "floor"
          return "switch_platform"
      else
        # debug "get up"
        return

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

    _findAIStateForPlatform: (platform) ->
      # Is the platform above us?
      platformPosition = platform.position
        .clone()
        .multiply Level.GRID_SIZE

      distY = - (@position.y - (@app.getHeight() - platformPosition.y))
      distX = platformPosition.x - @position.x

      @targetPlatform = platform

      if distY < 0
        # Do we have a ladder on our platform?
        # Yes -> Use it
        # No
          # Can we reach it by jumping?
          # Yes -> Jump
          # No -> Die in a fire.
      # Is the platform on the same level?
      else if distY is 0
        # Jump. Running won't help.
        @aiSwitchDirection = if distX < 0 then -1 else 1
        @aiSwitchAction = "jump"
        return "switch_platform"
      else
        # Platform is underneath us
        # We're definitely gonna switch the platform
        @aiSwitchDirection = if distX < 0 then -1 else 1

        # Check X distance
        if distX >= Level.GRID_SIZE * 3
          # Large distance -> Would jumping work?
          if distX >- Level.GRID_SIZE * 6
            # Yes -> Jump
            @aiSwitchAction = "jump"
          else
            # No -> Trial and error. Just run.
            @aiSwitchAction = "run"
        else
          # Small distance, try to run and hit the platform
          @aiSwitchAction = "run"

        return "switch_platform"

    _performAIAction: ->
      if @aiState is "idle"
        # chill.
        # Later: Move left and right every now and then
      else if @aiState is "switch_platform"
        @_performPlatformSwitch()

    _performPlatformSwitch: ->
      @velocity.x = @aiSwitchDirection * @speed.x
      @direction = @aiSwitchDirection

      if @_findCurrentPlatform() is @targetPlatform
        # We're done here.
        @velocity.x = 0
        if @onGround
          @_stopAIAction()
          @_performAICheck()

    _findCurrentPlatform: ->
      return @_findNextLowerPlatform false

    droppedPackage: ->
      @lastPackageInteraction = Date.now()

    pickedPackage: ->
      @droppedPackage()

  module.exports = Enemy
