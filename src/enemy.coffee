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

      # "switch_platform" state
      @aiSwitchDirection = 0
      @aiSwitchAction = null # run or jump

      # "chase" state
      @aiChaseDirection

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
      console.debug "Performing AI check"
      @objectOfInterest = @_findObjectOfInterest()
      if @objectOfInterest and @onGround
        @following = true
        @aiState = @_findAIState()

    _findObjectOfInterest: ->
      if @package.attachedMob is @player
        obj = @player
      else
        obj = @package

      platform = obj._findCurrentPlatform()
      floorPosition = @level.getRealFloorLevel()
      platformPosition = platform.getRealPosition?() || @level.getRealFloorLevel()

      distX = Math.pow(@position.x - obj.position.x, 2)
      distY = Math.pow(@position.y - platformPosition.y, 2)
      distance = Math.sqrt(distX + distY)

      debug "AI Distance", distance

      if distance < @interestDistance
        return { object: obj, platform: platform }

      return false

    _findAIState: ->
      floorPosition = @level.getRealFloorLevel()

      objectOfInterest = @objectOfInterest.object
      platformPosition = @objectOfInterest.platform.getRealPosition?() || floorPosition

      distX = objectOfInterest.position.x - @position.x
      distY = platformPosition.y - @position.y

      if distY > 0
        nextPlatform = @_findNextLowerPlatform distX, distY
        if nextPlatform
          newAIState = @_findAIStateForPlatform nextPlatform
          console.debug newAIState, @aiSwitchAction, if @aiSwitchDirection is -1 then "left" else "right"
          return newAIState
        else
          @aiSwitchDirection = if distX < 0 then -1 else 1
          @aiSwitchAction = "run"
          @targetPlatform = "floor"
          return "switch_platform"
      else if distY < 0
        # debug "get up"
        return
      else
        # Probably the same platform
        @aiChaseDirection = if distX < 0 then -1 else 1
        return "chase"

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
        absDistX = Math.abs distX
        if absDistX >= Level.GRID_SIZE * 3
          # Large distance -> Would jumping work?
          if absDistX >= Level.GRID_SIZE * 6
            # Yes -> Jump
            console.debug "Could reach the platform, jumping"
            @aiSwitchAction = "jump"
          else
            # No -> Trial and error. Just run.
            console.debug "Too large distance, lemming mode!"
            @aiSwitchAction = "run"
        else
          console.debug "Small distance, running"
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

    _performPlatformSwitch: ->
      currentPlatform = @_findCurrentPlatform()

      @velocity.x = @aiSwitchDirection * @speed.x
      @direction = @aiSwitchDirection

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
            @aiSwitchDirection
          )

          if reachedPlatformEdge
            @_jump()

    _performChase: ->
      @velocity.x = @aiChaseDirection * @speed.x
      @direction = @aiChaseDirection

    droppedPackage: ->
      @lastPackageInteraction = Date.now()

    pickedPackage: ->
      @droppedPackage()

  module.exports = Enemy
