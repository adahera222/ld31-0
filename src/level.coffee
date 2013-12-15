define (require, exports, module) ->
  LDFW = require "ldfw"
  Platform = require "level-objects/platform"
  Ladder = require "level-objects/ladder"
  LevelParser = require "level-parser"

  class Level
    @GRID_SIZE: 20
    floorHeight: 40
    constructor: (@app, @game, @fileName) ->
      @gravity = new LDFW.Vector2 0, 5000
      @platforms = []
      @ladders = []

      @scroll = new LDFW.Vector2

      @width = 0
      @height = 0

      @parser = new LevelParser @app, @game, this, @fileName
      @parser.parse()

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

    addPlatform: (x, y, width) ->
      y = @height - y
      platform = new Platform @app, @game, this, {
        width: width,
        position: new LDFW.Vector2 x, y
      }
      @platforms.push platform

    addLadder: (x, y) ->
      y = @height - y - 1
      ladder = new Ladder @app, @game, this, {
        position: new LDFW.Vector2 x, y
      }
      @ladders.push ladder

  module.exports = Level
