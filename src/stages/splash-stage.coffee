define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  SplashActor = require "actors/splash-actor"
  PackagesActor = require "actors/packages-actor"
  LogoActor = require "actors/logo-actor"

  ###
   * SplashStage definition
  ###
  class SplashStage extends LDFW.Stage
    constructor: (@app, @game) ->
      super @game

      @splashActor = new SplashActor @app, @game
      @addActor @splashActor

      @packagesActor = new PackagesActor @app, @game
      @addActor @packagesActor

      @logoActor = new LogoActor @app, @game
      @addActor @logoActor

    update: (delta) ->
      super

    draw: (context) ->
      {width, height} = context.canvas

      gradient = context.createLinearGradient 0, 0, 0, height
      gradient.addColorStop 0, "#73a7d0"
      gradient.addColorStop 1, "#568bb4"

      context.save()
      context.fillStyle = gradient
      context.fillRect 0, 0, width, height
      context.restore()

      super

  ###
   * Expose SplashStage
  ###
  module.exports = SplashStage
