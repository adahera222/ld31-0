define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  PlatformActor = require "actors/platform-actor"

  class StoreActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game

      @ended = false

      {@spriteSheet, @fontsSheet} = @app

      @biggerWhiteFont = new LDFW.BitmapFont(
        @app.preloader.get("assets/fonts/pixel-16.fnt"),
        @fontsSheet.findRegion("pixel-16-white.png")
      )
      @greyFont = new LDFW.BitmapFont(
        @app.preloader.get("assets/fonts/pixel-16.fnt"),
        @fontsSheet.findRegion("pixel-16-grey.png")
      )

      @storeSprite = @spriteSheet.createSprite "store.png"

      @textOpacity = 0
      @storeOpacity = 0
      @timePassed = 0

    update: (delta) ->
      super

      @timePassed += delta
      if @timePassed >= 0.5 and @timePassed < 3
        @textOpacity += delta
        @textOpacity = Math.min 1, @textOpacity
      else if @timePassed >= 4
        @textOpacity -= delta
        @textOpacity = Math.max 0, @textOpacity

      if @timePassed >= 5
        @storeOpacity += delta
        @storeOpacity = Math.min 1, @storeOpacity

      if @timePassed >= 8
        @ended = true

    draw: (context) ->
      {width, height} = context.canvas

      context.fillStyle = "#b2b2b2"
      context.fillRect 0, 0, width, height

      @_drawText context
      @_drawStore context

    _drawText: (context) ->
      context.save()
      context.globalAlpha = @textOpacity

      text = "NOVEMBER 15, 2013"
      bounds = @greyFont.getBounds text
      @greyFont.drawText context, text,
        @app.getWidth() / 2 - bounds.width / 2,
        200

      text = "PLAYSTATION 4 RELEASE DAY"
      bounds = @greyFont.getBounds text
      @greyFont.drawText context, text,
        @app.getWidth() / 2 - bounds.width / 2,
        240

      context.restore()

    _drawStore: (context) ->
      context.save()
      context.globalAlpha = @storeOpacity
      @storeSprite.draw context, 0, 120
      context.restore()

  module.exports = StoreActor
