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

    update: (delta) ->
      super

      @splashStage.update delta

    draw: (context) ->
      super

      @splashStage.draw context

  ###
   * Expose SplashScreen
  ###
  module.exports = SplashScreen
