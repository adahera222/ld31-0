define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  Level = require "level"
  LadderActor = require "actors/ladder-actor"
  PlatformActor = require "actors/platform-actor"

  class LevelActor extends LDFW.Actor
    GRID_SIZE: Level.GRID_SIZE
    constructor: (@app, @game) ->
      super @game

      {@level} = @game
      {@spriteSheet} = @app

      @ladderActor = new LadderActor @app, @game
      @platformActor = new PlatformActor @app, @game

      @floorSprite = @spriteSheet.createSprite "world/floor.png"

    draw: (context) ->
      @_drawBackground context
      @_drawFloor context
      @_drawPlatforms context
      @_drawLadders context

    _drawBackground: (context) ->
      @_drawVerticalBars context
      @_drawHorizontalBars context

    _drawVerticalBars: (context) ->
      barSpaceHeight = 140
      offset = @level.scroll.y % barSpaceHeight
      barsCount = Math.ceil @app.getHeight() / barSpaceHeight

      context.fillStyle = "rgba(255, 255, 255, 0.3)"
      for i in [-1...barsCount]
        context.fillRect(
          0,
          -offset + (i + 0.5) * barSpaceHeight,
          @app.getWidth(),
          4
        )

    _drawHorizontalBars: (context) ->
      barSpaceWidth = 130
      offset = @level.scroll.x % barSpaceWidth
      barsCount = Math.ceil @app.getWidth() / barSpaceWidth

      context.fillStyle = "#dadada"
      for i in [-1..barsCount]
        context.fillRect(
          -offset + (i + 0.5) * barSpaceWidth,
          0,
          10,
          @app.getHeight()
        )

    _drawFloor: (context) ->
      spriteWidth = @floorSprite.getWidth()
      offset = @level.scroll.x % spriteWidth
      spritesCount = Math.ceil @app.getWidth() / spriteWidth

      for i in [-1..spritesCount]
        @floorSprite.draw context,
          -offset + spriteWidth * i,
          @app.getHeight() - @floorSprite.getHeight() - @level.scroll.y

    _drawPlatforms: (context) ->
      context.fillStyle = "green"
      for platform in @level.platforms
        position = platform.position
          .clone()
          .multiply @GRID_SIZE
        platformWidth = platform.width * @GRID_SIZE

        @platformActor.draw context,
          position.x - @level.scroll.x,
          @app.getHeight() - position.y - @level.scroll.y,
          platformWidth

    _drawLadders: (context) ->
      for ladder in @level.ladders
        position = ladder.position
          .clone()
          .multiply @GRID_SIZE
        ladderHeight = ladder.height * @GRID_SIZE

        @ladderActor.draw context,
          position.x - @level.scroll.x,
          @app.getHeight() - position.y - ladderHeight - @level.scroll.y,


  module.exports = LevelActor
