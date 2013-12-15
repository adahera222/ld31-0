define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  ###
   * InstructionsScreen definition
  ###
  class InstructionsScreen extends LDFW.Screen
    constructor: (@app) ->
      super

      {@spriteSheet} = @app
      @sprite = @spriteSheet.createSprite "instructions.png"

      @keyboard = new LDFW.Keyboard
      @timePassed = 0

    update: (delta) ->
      super

      @timePassed += delta

      if @keyboard.pressed(@keyboard.Keys.ENTER) and @timePassed > 0.3
        @app.switchToGameScreen()

    draw: (context) ->
      context.globalAlpha = 1
      @sprite.draw context, 0, 0

  ###
   * Expose InstructionsScreen
  ###
  module.exports = InstructionsScreen
