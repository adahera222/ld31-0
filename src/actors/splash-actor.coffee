define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  PlatformActor = require "actors/platform-actor"

  class SplashActor extends LDFW.Actor
    GRID_SIZE: 20
    constructor: (@app, @game) ->
      super @game

      {@spriteSheet, @fontsSheet} = @app

      @platformActor = new PlatformActor @app, @game

      @floorSprite = @spriteSheet.createSprite "world/floor.png"
      @wallSprite = @spriteSheet.createSprite "world/wall.png"

      @biggerWhiteFont = new LDFW.BitmapFont(
        @app.preloader.get("assets/fonts/pixel-16.fnt"),
        @fontsSheet.findRegion("pixel-16-white.png")
      )

    draw: (context) ->
      @_drawBackground context
      @_drawWall context
      @_drawFloor context
      @_drawPlatforms context
      @_drawText context

    _drawBackground: (context) ->
      @_drawVerticalBars context
      @_drawHorizontalBars context

    _drawVerticalBars: (context) ->
      barSpaceHeight = 160
      barsCount = Math.ceil @app.getHeight() / barSpaceHeight

      context.fillStyle = "rgba(255, 255, 255, 0.3)"
      for i in [-1...barsCount]
        context.fillRect(
          0,
          (i + 0.5) * barSpaceHeight,
          @app.getWidth(),
          4
        )

    _drawHorizontalBars: (context) ->
      barSpaceWidth = 130
      barsCount = Math.ceil @app.getWidth() / barSpaceWidth

      context.fillStyle = "#dadada"
      for i in [-1..barsCount]
        context.fillRect(
          (i + 0.5) * barSpaceWidth,
          0,
          10,
          @app.getHeight()
        )

    _drawFloor: (context) ->
      spriteWidth = @floorSprite.getWidth()
      spritesCount = Math.ceil @app.getWidth() / spriteWidth

      for i in [-1..spritesCount]
        @floorSprite.draw context,
          spriteWidth * i,
          @app.getHeight() - @floorSprite.getHeight()

    _drawWall: (context) ->
      spriteWidth = @wallSprite.getWidth()
      spritesCount = Math.ceil @app.getWidth() / spriteWidth

      for i in [-1..spritesCount]
        @wallSprite.draw context,
          spriteWidth * i,
          @app.getHeight() - @wallSprite.getHeight() - @GRID_SIZE * 2

    _drawPlatforms: (context) ->
      @platformActor.draw context,
        0,
        @app.getHeight() - @GRID_SIZE * 9,
        @app.getWidth()

    _drawText: (context) ->
      text = "PRESS ENTER TO START"
      bounds = @biggerWhiteFont.getBounds text
      @biggerWhiteFont.drawText context, text, @app.getWidth() / 2 - bounds.width / 2, 360

  module.exports = SplashActor
