define (require, exports, module) ->
  LDFW = require "ldfw"
  Mob = require "mob"
  Level = require "level"
  Exit = require "level-objects/exit"

  class Enemy extends Mob
    interestDistance: 400
    loseInterestDistance: 800
    constructor: (@app, @game) ->
      super

      {@player, @package, @level} = @game

      @following = false
      @aiState = "idle"
      @lastAICheck = Date.now()

      @speed = new LDFW.Vector2 500, 500

      @aiSwitchAction = null # run or jump
      @aiDirection = 0

    update: (delta) ->
      super

      debug @aiState

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
      ooiData = @_findObjectOfInterest()

      # Gain interest
      if (not @objectOfInterest or
        (@objectOfInterest and @objectOfInterest.object isnt ooiData.object)) and
        (ooiData.distance < @interestDistance or ooiData.ignoreDistance)
          @objectOfInterest = ooiData
          @aiState = @_findAIState()
          @following = true

      # Lose interest
      else if @objectOfInterest and
        (ooiData.distance > @loseInterestDistance and not ooiData.ignoreDistance)
          @objectOfInterest = null
          @_stopAIAction()
          @following = false

      else if @objectOfInterest and @onGround
        @objectOfInterest.platform = @objectOfInterest
          .object
          ._findCurrentPlatform()
        @aiState = @_findAIState()

    _findObjectOfInterest: ->
      if @package.attachedMob is @player
        obj = @player
      else if @package.attachedMob is this
        # I HAZ PACKAGE LOLZ
        obj = @level.exits[0]
      else
        obj = @package

      platform = obj._findCurrentPlatform()

      if obj instanceof Exit
        return { object: obj, platform: platform, ignoreDistance: true }

      floorPosition = @level.getRealFloorLevel()
      platformPosition = platform.getRealPosition?() || @level.getRealFloorLevel()

      distX = Math.pow(@position.x - obj.position.x, 2)
      distY = Math.pow(@position.y - platformPosition.y, 2)
      distance = Math.sqrt(distX + distY)

      return { object: obj, platform: platform, distance: distance }

    _findAIState: ->
      floorPosition = @level.getRealFloorLevel()

      objectOfInterest = @objectOfInterest.object
      platformPosition = @objectOfInterest.platform.getRealPosition?() || floorPosition

      ooiPosition = objectOfInterest.getRealPosition()
      distX = ooiPosition.x - @position.x
      distY = platformPosition.y - @position.y

      if distY > 0
        nextPlatform = @_findNextLowerPlatform ooiPosition

        if nextPlatform
          newAIState = @_findAIStateForPlatform nextPlatform
          return newAIState
        else
          @aiDirection = if distX < 0 then -1 else 1
          @aiSwitchAction = "run"
          @targetPlatform = "floor"
          return "switch_platform"
      else if distY < 0
        nextPlatform = @_findNextHigherPlatform ooiPosition
        if nextPlatform
          newAIState = @_findAIStateForPlatform nextPlatform
          return newAIState
        else
          # No chance... Actually, this should never happen.
          return "idle"
      else
        # Probably the same platform
        @aiDirection = if distX < 0 then -1 else 1
        return "chase"

    _findAIStateForPlatform: (platform) ->
      # Is the platform above us?
      platformPosition = platform.position
        .clone()
        .multiply Level.GRID_SIZE

      distY = - (@position.y - (@app.getHeight() - platformPosition.y))
      distX = platformPosition.x - @position.x

      currentPlatform = @_findCurrentPlatform()
      @targetPlatform = platform

      if distY < 0
        # Do we have a ladder on our platform?
        ladderOnPlatform = @level.findLadderOnPlatform currentPlatform
        if ladderOnPlatform
          # Yes -> Use it
          @aiTargetLadder = ladderOnPlatform
          distX = ladderOnPlatform.getRealPosition().x - @position.x
          @aiDirection = if distX < 0 then -1 else 1
          return "walk_to_ladder"
        else
          # No
          @aiDirection = if distX < 0 then -1 else 1
          @aiSwitchAction = "jump"
          return "switch_platform"
      # Is the platform on the same level?
      else if distY is 0
        # Jump. Running won't help.
        @aiDirection = if distX < 0 then -1 else 1
        @aiSwitchAction = "jump"
        return "switch_platform"
      else
        # Platform is underneath us
        # We're definitely gonna switch the platform
        @aiDirection = if distX < 0 then -1 else 1

        # Check X distance
        absDistX = Math.abs distX
        if absDistX >= Level.GRID_SIZE * 3
          # Large distance -> Would jumping work?
          if absDistX >= Level.GRID_SIZE * 6
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
      else if @aiState is "chase"
        @_performChase()
      else if @aiState is "walk_to_ladder"
        @_performWalkToLadder()
      else if @aiState is "climb"
        @_performClimb()

    _performPlatformSwitch: ->
      currentPlatform = @_findCurrentPlatform()

      @velocity.x = @aiDirection * @speed.x
      @direction = @aiDirection

      if currentPlatform is @targetPlatform
        # We're done here.
        @velocity.x = 0
        if @onGround
          @_stopAIAction()
          @_performAICheck()
      else if @aiSwitchAction is "jump"
        if currentPlatform is "floor"
          # We need some other logic here:
          #  - Jump if the x-distance to the platform
          #    is small enough
        else
          # If we are 1 GRID_SIZE away from the
          # platform edge, jump.
          reachedPlatformEdge = @_isAtPlatformEdge(
            currentPlatform,
            @aiDirection
          )

          if reachedPlatformEdge
            @_jump()

    _performChase: ->
      @velocity.x = @aiDirection * @speed.x
      @direction = @aiDirection

    _performWalkToLadder: ->
      @velocity.x = @aiDirection * @speed.x
      @direction = @aiDirection

      if @level.isMobTouchingLadder(this, @aiTargetLadder, true)
        @_stopAIAction()
        @aiState = "climb"

    _performClimb: ->
      @_climb()
      unless @level.isMobTouchingLadder(this, @aiTargetLadder)
        @_stopAIAction()
        @_stopClimbing()

    _climb: ->
      @onLadder = true
      @ignoreGravity = true
      @velocity.y = -@speed.y

    _stopClimbing: ->
      @ignoreGravity = false
      @onLadder = false

    droppedPackage: ->
      @lastPackageInteraction = Date.now()

    pickedPackage: ->
      @droppedPackage()

  module.exports = Enemy
