define (require, exports, module) ->
  LDFW = require "ldfw"

  Platform = require "level-objects/platform"
  Ladder = require "level-objects/ladder"
  Exit = require "level-objects/exit"

  LevelParser = require "level-parser"

  class Level
    @GRID_SIZE: 20
    floorHeight: 40
    constructor: (@app, @game, @fileName) ->
      @gravity = new LDFW.Vector2 0, 5000
      @platforms = []
      @ladders = []
      @exits = []

      @scroll = new LDFW.Vector2

      @width = 0
      @height = 0

      @parser = new LevelParser @app, @game, this, @fileName

    parse: -> @parser.parse()
    update: -> debug

    isMobTouchingLadder: (mob, specificLadder, fullyOnLadder = false) ->
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
                if not specificLadder or specificLadder is ladder
                  return ladder

      return false

    getBoundariesForObject: (obj) ->
      boundaries =
        x:
          min: 0
          max: @width * Level.GRID_SIZE - obj.width
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

    findClosestLadderOnPlatform: (platform, position) ->
      filteredLadders = []
      for ladder in @ladders
        if ladder.position.y is (platform.position?.y or @floorHeight / Level.GRID_SIZE)
          filteredLadders.push ladder

      filteredLadders.sort (a, b) ->
        distA = Math.abs(position.x - a.getRealPosition().x)
        distB = Math.abs(position.x - b.getRealPosition().x)

        return distA - distB

      return filteredLadders[0]

    findPlatformAbove: (x, y) ->
      platforms = @platforms.slice()
      platforms.sort (a, b) ->
        a.position.y - b.position.y


      for platform in platforms
        {position, width} = platform

        unless position.x > x or
          position.x + width < x or
          position.y < y
            return platform

      return false

    addPlatform: (x, y, width) ->
      platform = new Platform @app, @game, this, {
        width: width,
        position: new LDFW.Vector2 x, y
      }

      @platforms.push platform

    addLadder: (x, y, height) ->
      y = y - 1
      ladder = new Ladder @app, @game, this, {
        position: new LDFW.Vector2 x, y
        height: height
      }
      @ladders.push ladder

    addExit: (x, y) ->
      y = @height - y - 1
      exit = new Exit @app, @game, this, {
        position: new LDFW.Vector2 x, y
      }
      @exits.push exit

  module.exports = Level
