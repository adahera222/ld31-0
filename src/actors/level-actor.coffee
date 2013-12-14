define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  Level = require "level"
  LadderActor = require "actors/ladder-actor"

  class LevelActor extends LDFW.Actor
    GRID_SIZE: Level.GRID_SIZE
    constructor: (@app, @game) ->
      super @game

      {@level} = @game
      {@spriteSheet} = @app
      @ladderActor = new LadderActor @app, @game

      @floorSprite = @spriteSheet.createSprite "world/floor.png"

    draw: (context) ->
      @_drawFloor context
      @_drawPlatforms context
      @_drawLadders context

    _drawFloor: (context) ->
      spriteWidth = @floorSprite.getWidth()
      offset = @level.scroll.x % spriteWidth
      spritesCount = Math.ceil @app.getWidth() / spriteWidth

      for i in [-1..spritesCount]
        @floorSprite.draw context, -offset + spriteWidth * i, @app.getHeight() - @floorSprite.getHeight()

    _drawPlatforms: (context) ->
      context.fillStyle = "green"
      for platform in @level.platforms
        position = platform.position
          .clone()
          .multiply @GRID_SIZE
        platformWidth = platform.width * @GRID_SIZE

        context.fillRect(
          position.x - @level.scroll.x,
          @app.getHeight() - position.y,
          platformWidth,
          @GRID_SIZE
        )

    _drawLadders: (context) ->
      for ladder in @level.ladders
        position = ladder.position
          .clone()
          .multiply @GRID_SIZE
        ladderHeight = ladder.height * @GRID_SIZE

        @ladderActor.draw context,
          position.x - @level.scroll.x,
          @app.getHeight() - position.y - ladderHeight,


  module.exports = LevelActor
