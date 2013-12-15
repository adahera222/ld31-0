define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  SplashStage = require "stages/splash-stage"

  ###
   * SplashScreen definition
  ###
  class SplashScreen extends LDFW.Screen
    constructor: (@app) ->
      super

      @splashStage = new SplashStage @app, @game
      @keyboard = new LDFW.Keyboard

    update: (delta) ->
      super

      @splashStage.update delta
      if @keyboard.pressed @keyboard.Keys.ENTER
        @game.switchToIntroScreen()

    draw: (context) ->
      super

      @splashStage.draw context

  ###
   * Expose SplashScreen
  ###
  module.exports = SplashScreen
