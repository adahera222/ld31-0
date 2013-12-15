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

    update: (delta) ->
      super

      if @keyboard.pressed @keyboard.Keys.ENTER
        @app.switchToGameScreen()

    draw: (context) ->
      context.globalAlpha = 1
      @sprite.draw context, 0, 0

  ###
   * Expose InstructionsScreen
  ###
  module.exports = InstructionsScreen
