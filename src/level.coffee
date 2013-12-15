define (require, exports, module) ->
  LDFW = require "ldfw"
  Platform = require "level-objects/platform"
  Ladder = require "level-objects/ladder"

  class Level
    @GRID_SIZE: 20
    floorHeight: 40
    constructor: (@app, @game) ->
      @gravity = new LDFW.Vector2 0, 5000
      @platforms = []
      @ladders = []

      @scroll = new LDFW.Vector2

      @platforms.push new Platform @app, @game, this, {
        position: new LDFW.Vector2 4, 10
        width: 13
      }
      @platforms.push new Platform @app, @game, this, {
        position: new LDFW.Vector2 10, 17
        width: 8
      }
      @platforms.push new Platform @app, @game, this, {
        position: new LDFW.Vector2 23, 21
        width: 8
      }

      @ladders.push new Ladder @app, @game, this, {
        position: new LDFW.Vector2 9, 2
      }
      @ladders.push new Ladder @app, @game, this, {
        position: new LDFW.Vector2 14, 10
      }

    update: -> debug

    isMobTouchingLadder: (mob, fullyOnLadder = false) ->
      for ladder in @ladders
        ladderPosition = ladder.position
          .clone()
          .multiply Level.GRID_SIZE
        ladderHeight = ladder.height * Level.GRID_SIZE
        ladderWidth = Level.GRID_SIZE * 2

        # Horizontal check
        unless fullyOnLadder
          # For manual user interaction
          minCoverage = 0.3 * Level.GRID_SIZE
        else
          # For AI interaction
          minCoverage = 1.5 * Level.GRID_SIZE

        unless (mob.position.x + mob.width < ladderPosition.x + minCoverage or
          mob.position.x > ladderPosition.x + ladderWidth - minCoverage)

            # Vertical check
            ladderY = (@app.getHeight() - ladderPosition.y - ladderHeight)
            unless (mob.position.y <= ladderY or
              mob.position.y - mob.height >= ladderY + ladderHeight)
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
          max: @app.getHeight() - @floorHeight
          object: null

      # Check for platform collisions
      for platform in @platforms
        platformPosition = platform.position
          .clone()
          .multiply Level.GRID_SIZE
        platformWidth = platform.width * Level.GRID_SIZE

        # Horizontal check
        if obj.position.x + obj.width > platformPosition.x and
          obj.position.x < platformPosition.x + platformWidth

            # Vertical check
            platformY = (@app.getHeight() - platformPosition.y)
            if obj.position.y <= platformY <= boundaries.y.max
              boundaries.y.max = platformY

      return boundaries

    getRealFloorLevel: ->
      new LDFW.Vector2(0, @app.getHeight() - @floorHeight)

    findLadderOnPlatform: (platform) ->
      for ladder in @ladders
        if ladder.position.y is (platform.position?.y or @floorHeight / Level.GRID_SIZE)
          return ladder

      return false

  module.exports = Level
