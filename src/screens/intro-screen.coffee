define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  IntroStage = require "stages/intro-stage"

  ###
   * IntroScreen definition
  ###
  class IntroScreen extends LDFW.Screen
    constructor: (@app) ->
      super

      @introStage = new IntroStage @app

    update: (delta) ->
      super

      @introStage.update delta

    draw: (context) ->
      super

      @introStage.draw context

  ###
   * Expose IntroScreen
  ###
  module.exports = IntroScreen
